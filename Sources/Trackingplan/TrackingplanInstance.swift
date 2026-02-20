//
//  TrackingplanInstance.swift
//  Trackingplan
//
//  Created by José Padilla López on 5/7/24.
//

import Foundation
import UIKit
import TrackingplanShared

open class TrackingplanInstance {

    private static let interceptor = NetworkInterceptor()

    private let logger: TrackingPlanLogger

    private let networkManager: TrackingplanNetworkManager
    internal var config: TrackingplanConfig

    internal var currentSession: TrackingplanShared.TrackingplanSession?
    private let storage: TrackingplanShared.Storage

    var serialQueue: DispatchQueue

    init?(config: TrackingplanConfig) {
        guard let storage = StorageMigration.createWithMigration(tpId: config.tp_id, environment: config.environment) else {
            TrackingplanManager.logger.debug("Failed to create storage")
            return nil
        }
        self.storage = storage
        self.config = config
        logger = TrackingplanManager.logger
        serialQueue = DispatchQueue(label: "com.trackingplan.main-thread", qos: .utility)
        networkManager = TrackingplanNetworkManager(config: config, serialQueue: self.serialQueue, storage: storage)
        setupObservers()
    }

    /// Process a request for testing purposes. Must be called from tests only.
    func processRequest(_ urlRequest: URLRequest) {
        serialQueue.sync {
            networkManager.processRequest(urlRequest: urlRequest)
        }
    }

    /// Flush the queue and wait for completion. Must be called from tests only.
    func flushQueue(completion: (() -> Void)? = nil) {
        let semaphore = DispatchSemaphore(value: 0)
        serialQueue.async {
            self.networkManager.resolveStackAndSend { _ in
                semaphore.signal()
                completion?()
            }
        }
        _ = semaphore.wait(timeout: .now() + 5.0)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }

    func start(){
        // Start interception. Requests arriving before session initialization are pre-queued
        // and processed when the session becomes available.
        let requestSniffers = [
            RequestSniffer(requestEvaluator: AnyHttpRequestEvaluator(), handlers: [
                TrackingplanRequestHandler(serialQueue: self.serialQueue, networkManager: self.networkManager)
            ])
        ]
        let networkConfig = NetworkInterceptorConfig(requestSniffers: requestSniffers)
        NetworkInterceptor.shared.setup(config: networkConfig)
        NetworkInterceptor.shared.startRecording()

        // Start session
        serialQueue.async {
            self.startSession()
        }
    }

    public func stop(){
        NetworkInterceptor.shared.stopRecording()
        serialQueue.async {
            self.networkManager.clearPreQueue()
            self.networkManager.clearQueue()
            self.stopSession()
        }
    }

    private func startSession() {

        // Force loading/downloading ingest config every 24 hours as it might not
        // be downloaded in case of long sessions (a session spanning over a period larger than 24 hours).
        let _ = loadOrDownloadIngestConfig()

        // Note that new session is started (and previous one is expired) after a period of inactivity
        // Let's assume that queue was empty before the app received new activity so any pending
        // requests in the queue should be attributed to the new session. In other words, there is
        // no need to flush the queue before starting a new session.
        let session = restoreOrCreateSession();

        if session.sessionId == currentSession?.sessionId {
            logger.debug("Session already started. Start ignored")
            return
        }

        if session.isNew {
            logger.debug("New session started: \(session)")
        } else {
            logger.debug("Session resumed: \(session)")
        }

        // Trigger new_session event every time a new session is started
        if session.isNew {
            networkManager.queueTrackingplanEvent(eventName: "new_session")
        }

        // Trigger new_dau event if last one was sent 24h ago
        if storage.wasLastDauSent24hAgo() {
            networkManager.queueTrackingplanEvent(eventName: "new_dau")
        }

        // Trigger new_user event the first time it is executed.
        if storage.isFirstTimeExecution() {
            networkManager.queueTrackingplanEvent(eventName: "new_user")
        }

        // All events triggered during startSession should have been queued before this assignment
        networkManager.currentSession = session
        currentSession = session

        // Process pre-queued requests through normal flow (includes adaptive sampling)
        networkManager.processPreQueue()

        // Send any pending requests (including those rescued by adaptive sampling)
        if networkManager.queueSize() > 0 {
            networkManager.resolveStackAndSend { success in

                if !success { return }

                if self.storage.isFirstTimeExecution() {
                    self.storage.saveFirstTimeExecutionNow()
                }

                if self.storage.wasLastDauSent24hAgo() {
                    self.storage.saveLastDauEventSentTimeNow()
                }
            }
        }
    }

    private func stopSession() {
        guard let currentSession = currentSession else {
            return
        }
        if currentSession.updateLastActivity() {
            storage.saveSession(session: currentSession)
            logger.debug("Last session activity updated and saved")
        }
    }

    private func restoreOrCreateSession() -> TrackingplanShared.TrackingplanSession {

        let session = storage.loadSession()

        // Restore session
        if !session.hasExpired() {
            logger.verbose("Previous session found and is still valid")
            if session.updateLastActivity() {
                storage.saveSession(session: session)
                logger.verbose("Last session activity updated and saved")
            }
            return session
        }

        logger.debug("Previous session expired or doesn't exist. Creating a new session...")

        var newSession: TrackingplanShared.TrackingplanSession

        let ingestConfig = loadOrDownloadIngestConfig()
        if let ingestConfig = ingestConfig, !storage.ingestConfigCache.hasExpired() {
            let samplingRate = ingestConfig.getSamplingRate(environment: config.environment)
            let trackingEnabled = storage.loadTrackingEnabled()
            let samplingOptions = ingestConfig.options
            newSession = TrackingplanShared.TrackingplanSession.companion.doNewSession(samplingRate: samplingRate, trackingEnabled: trackingEnabled, samplingOptions: samplingOptions)
            let trackingStatus = newSession.trackingEnabled ? "enabled" : "disabled"
            logger.debug("New session created with tracking \(trackingStatus)")
        } else {
            newSession = TrackingplanShared.TrackingplanSession.companion.doNewSession(samplingRate: session.samplingRate, trackingEnabled: false, samplingOptions: SamplingOptions.companion.EMPTY)
            logger.debug("New session created with tracking disabled because ingest config was outdated")
        }

        storage.saveSession(session: newSession)
        logger.verbose("Session saved")

        return newSession
    }

    /// Loads the ingest config from cache or downloads it if expired/missing.
    /// - Returns: The ingest config, or nil if download failed
    private func loadOrDownloadIngestConfig() -> TrackingplanShared.TrackingplanIngestConfig? {

        // Try loading from cache first
        if let cachedConfig = storage.ingestConfigCache.loadIfValid() {
            logger.debug("Previous ingest config found and is still valid")
            logger.debug("Sampling rate: \(cachedConfig.getSamplingRate(environment: config.environment))")
            return cachedConfig
        }

        TrackingplanManager.logger.debug("Ingest config expired or not found. Downloading...")

        if config.ignoreSampling {
            let fakeConfigJson = "{\"sample_rate\": 1}"
            try? storage.ingestConfigCache.save(jsonContent: fakeConfigJson)
            let fakeConfig = try! TrackingplanShared.TrackingplanIngestConfigParser.shared.parse(jsonString: fakeConfigJson)
            let trackingEnabled = fakeConfig.shouldEnableTracking(environment: config.environment)
            storage.saveTrackingEnabled(enabled: trackingEnabled)
            TrackingplanManager.logger.debug("Ingest config downloaded and saved")
            TrackingplanManager.logger.debug("Sampling rate: \(fakeConfig.getSamplingRate(environment: config.environment))")
            return fakeConfig
        }

        // Do sync download since this function must be called from Trackingplan serialQueue
        var numAttempts = 2
        var ingestConfig: TrackingplanShared.TrackingplanIngestConfig? = nil

        while numAttempts > 0 {
            if let rawJson = networkManager.downloadIngestConfigRawSync() {
                do {
                    try storage.ingestConfigCache.save(jsonContent: rawJson)
                    if let downloadedConfig = storage.ingestConfigCache.loadIfValid() {
                        let trackingEnabled = downloadedConfig.shouldEnableTracking(environment: config.environment)
                        storage.saveTrackingEnabled(enabled: trackingEnabled)
                        TrackingplanManager.logger.debug("Ingest config downloaded and saved")
                        TrackingplanManager.logger.debug("Sampling rate: \(downloadedConfig.getSamplingRate(environment: config.environment))")
                        ingestConfig = downloadedConfig
                        break
                    } else {
                        TrackingplanManager.logger.debug("Failed to parse or validate downloaded config")
                    }
                } catch {
                    TrackingplanManager.logger.debug("Error saving ingest config: \(error)")
                }
            }
            numAttempts -= 1
            if numAttempts > 0 {
                sleep(1)
            }
        }

        if ingestConfig == nil {
            // Retry in 5 minutes
            // TODO: Cancel any previous retry
            serialQueue.asyncAfter(deadline: .now() + 300) { let _ = self.loadOrDownloadIngestConfig() }
        }

        return ingestConfig
    }

    @discardableResult
    static func sharedUIApplication() -> UIApplication? {
        guard let sharedApplication = UIApplication.perform(NSSelectorFromString("sharedApplication"))?.takeUnretainedValue() as? UIApplication
        else {
            return nil
        }
        return sharedApplication
    }

    @objc private func applicationWillEnterForeground(_ notification: Notification) {
        serialQueue.async {
            TrackingplanManager.logger.debug("onResume lifecycle called")
            self.startSession()
        }
    }

    @objc private func applicationDidEnterBackground(_ notification: Notification) {
        // Max permited execution time is 5 seconds. So request extra time to perform some tasks before suspend
        let taskId = Utils.startBackgroundTask(name: "WaitForRequests")

        // Wait 2s as grace period to intercept new events before sending pending events from the queue
        serialQueue.asyncAfter(deadline: .now() + 2.0) {
            self.networkManager.resolveStackAndSend()
            Utils.endBackgroundTask(taskId)
        }

        serialQueue.sync {
            TrackingplanManager.logger.debug("onPause lifecycle called")
            self.stopSession()
        }
    }

    func updateTags(_ newTags: Dictionary<String, String>) {
        serialQueue.async {
            // Create a new immutable config with merged tags
            self.config = self.config.withTags(newTags, replace: false)
            self.networkManager.updateConfig(self.config)
            TrackingplanManager.logger.debug("Tags updated: \(newTags.keys.joined(separator: ", "))")
        }
    }
}
