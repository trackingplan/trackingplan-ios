//
//  File.swift
//
//
//  Created by José Padilla López on 5/7/24.
//

import Foundation
import UIKit

open class TrackingplanInstance {
    
    private static let interceptor = NetworkInterceptor()
    
    private let logger: TrackingPlanLogger
    
    private let networkManager: TrackingplanNetworkManager
    internal var config: TrackingplanConfig
    
    private var currentSession: TrackingplanSession?
    private let storage: Storage
    
    var serialQueue: DispatchQueue
    
    init?(config: TrackingplanConfig) {
        guard let storage = Storage(tpId: config.tp_id, environment: config.environment) else {
            return nil
        }
        self.storage = storage
        self.config = config
        logger = TrackingplanManager.logger
        serialQueue = DispatchQueue(label: "com.trackingplan.main-thread", qos: .utility)
        networkManager = TrackingplanNetworkManager(config: config, serialQueue: self.serialQueue, storage: storage)
        setupObservers()
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
        // Start interception. Note that interception will discard requests before a session is started or resumed. However,
        // it is started first for debugging purposes. For example, to see in logs if there were requests intercepted before
        // a session was available
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
            self.stopSession()
        }
    }
    
    private func startSession() {
        
        // Force getting the sampling rate in order to trigger download every 24 hour as it might not
        // be downloaded in case of long sessions (a session spanning over a period larger than 24 hours).
        let _ = getSamplingRate();
        
        // Note that new session is started (and previous one is expired) after a period of inactivity
        // Let's assume that queue was empty before the app received new activity so any pending
        // requests in the queue should be attributed to the new session. In other words, there is
        // no need to flush the queue before starting a new session.
        let session = restoreOrCreateSession();
        
        if session.sessionId == currentSession?.sessionId {
            logger.debug(message: TrackingplanMessage.message("Session already started. Start ignored"))
            return
        }
        
        if session.isNew {
            logger.debug(message: TrackingplanMessage.message("New session started: \(session)"))
        } else {
            logger.debug(message: TrackingplanMessage.message("Session resumed: \(session)"))
        }
        
        // Note that session must be assigned before calling networkManager.queueTrackingplanEvent. Otherwise, trackingplan events
        // will be automatically discarded.
        networkManager.currentSession = session
        currentSession = session
        
        if (session.trackingEnabled) {
            // Trigger new_dau event if last one was sent 24h ago
            if storage.wasLastDauSent24hAgo() {
                networkManager.queueTrackingplanEvent(eventName: "new_dau")
            }
            
            // Trigger new_session event every time a new session is started
            if session.isNew {
                networkManager.queueTrackingplanEvent(eventName: "new_session")
            }
            
            // Trigger new_user event the first time it is executed.
            if storage.isFirstTimeExecution() {
                networkManager.queueTrackingplanEvent(eventName: "new_user")
            }
            
            if networkManager.queueSize() > 0 {
                // Send trackingplan events from the queue
                networkManager.resolveStackAndSend { success in
                    
                    if !success { return }
                    
                    if self.storage.isFirstTimeExecution() {
                        self.storage.saveFirstTimeExecution()
                    }
                    
                    if self.storage.wasLastDauSent24hAgo() {
                        self.storage.saveLastDauEventSentTime()
                    }
                }
            }
        } else {
            // Discard pending messages that will never be sent
            networkManager.clearQueue()
        }
    }
    
    private func stopSession() {
        guard let currentSession = currentSession else {
            return
        }
        if currentSession.updateLastActivity() {
            storage.saveSession(session: currentSession)
            logger.debug(message: TrackingplanMessage.message("Last session activity updated and saved"))
        }
    }
    
    private func restoreOrCreateSession() -> TrackingplanSession {
        
        // Restore session
        if let session = storage.loadSession(), !session.hasExpired() {
            logger.debug(message: TrackingplanMessage.message("Previous session found and is still valid"))
            if session.updateLastActivity() {
                storage.saveSession(session: session)
                logger.debug(message: TrackingplanMessage.message("Last session activity updated and saved"))
            }
            return session
        }
        
        logger.debug(message: TrackingplanMessage.message("Previous session expired or doesn't exist. Creating a new session..."))
        
        var session: TrackingplanSession
        
        if let samplingRate = getSamplingRate(), !samplingRate.hasExpired() {
            session = TrackingplanSession(samplingRate: samplingRate.value, trackingEnabled: samplingRate.trackingEnabled)
            let trackingStatus = session.trackingEnabled ? "enabled" : "disabled"
            logger.debug(message: TrackingplanMessage.message("New session created with tracking \(trackingStatus)"))
        } else {
            session = TrackingplanSession(samplingRate: Int.max, trackingEnabled: false)
            logger.debug(message: TrackingplanMessage.message("New session created with tracking disabled because sampling rate was outdated"))
        }
        
        storage.saveSession(session: session)
        logger.debug(message: TrackingplanMessage.message("Session saved"))
        
        return session
    }
    
    private func getSamplingRate() -> SamplingRate? {
        
        if let samplingRate = storage.loadSamplingRate(), !samplingRate.hasExpired() {
            logger.debug(message: TrackingplanMessage.message("Previous sampling rate found and is still valid"))
            logger.debug(message: TrackingplanMessage.message("Sampling: \(samplingRate)"))
            return samplingRate
        }
        
        TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Sampling rate expired. Downloading..."))
        
        if config.ignoreSampling {
            let samplingRate = SamplingRate(samplingRate: 1)
            storage.saveSamplingRate(samplingRate: samplingRate)
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Sampling rate downloaded and saved"))
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Sampling: \(samplingRate)"))
            return samplingRate
        }
        
        // Do sync download since this function must be called from Trackingplan serialQueue
        var numAttempts = 2
        
        while (numAttempts > 0) {
            if let samplingRateValue = networkManager.downloadSamplingRateSync() {
                let samplingRate = SamplingRate(samplingRate: samplingRateValue)
                storage.saveSamplingRate(samplingRate: samplingRate)
                TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Sampling rate downloaded and saved"))
                TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Sampling: \(samplingRate)"))
                return samplingRate
            }
            numAttempts -= 1
            if numAttempts > 0 {
                sleep(1)
            }
        }
        
        // Retry in 5 minutes
        // TODO: Cancel any previous retry
        serialQueue.asyncAfter(deadline: .now() + 300) { let _ = self.getSamplingRate() }
        
        return nil
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
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("onResume lifecycle called"))
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
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("onPause lifecycle called"))
            self.stopSession()
        }
    }
    
    func updateTags(_ newTags: Dictionary<String, String>) {
        serialQueue.async {
            self.config.tags.merge(newTags) { _, new in new }
            self.networkManager.updateConfig(self.config)
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Tags updated: \(newTags.keys.joined(separator: ", "))"))
        }
    }
}
