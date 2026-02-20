//
//  TrackingplanNetworkManager.swift
//  Trackingplan
//

import Foundation
import UIKit
import TrackingplanShared


class TrackingplanNetworkManager {

    private static let trackingplanProvider = "trackingplan"

    private static let batchTimeoutSecs: TimeInterval = 30.0

    private var config: TrackingplanConfig
    var currentSession: TrackingplanShared.TrackingplanSession?
    private let trackQueue: TrackingplanQueue
    private let logger: TrackingPlanLogger
    private let serialQueue: DispatchQueue
    private let storage: TrackingplanShared.Storage
    private var watcher: DispatchWorkItem?
    private var preQueue: [TrackingplanTrackRequest] = []

    init(config: TrackingplanConfig, serialQueue: DispatchQueue, storage: TrackingplanShared.Storage) {
        self.config = config
        self.serialQueue = serialQueue
        self.storage = storage
        logger = TrackingplanManager.logger
        trackQueue = TrackingplanQueue.sharedInstance
    }
    
    func updateConfig(_ config: TrackingplanConfig) {
        self.config = config
    }

    // This method must be called from serialQueue
    func processRequest(urlRequest: URLRequest) {
        let trackRequest = TrackingplanTrackRequest(urlRequest: urlRequest)
        processRequest(trackRequest: trackRequest)
    }

    private func processRequest(trackRequest: TrackingplanTrackRequest) {

        let url = trackRequest.endpoint
        let method = trackRequest.method ?? "UNKNOWN"

        // Always ignore trackingplan endpoints
        if url.hasPrefix(config.trackingplanEndpoint) || url.hasPrefix(config.trackingplanConfigEndpoint) {
            return
        }

        // PreQueue raw requests that arrive before session is available.
        // Defer provider detection until processing, so custom domains are properly matched.
        guard let currentSession = currentSession else {
            preQueue.append(trackRequest)
            logger.verbose("Request pre-queued (session not ready): \(method) \(url)")
            return
        }

        // Normal flow: validate, evaluate sampling, and queue
        processRequestWithSession(trackRequest: trackRequest, session: currentSession)
    }

    private func processRequestWithSession(trackRequest: TrackingplanTrackRequest, session: TrackingplanSession) {
        let url = trackRequest.endpoint
        let method = trackRequest.method ?? "UNKNOWN"
        logger.verbose("Processing request \(method) \(url)")

        guard let provider = self.getAnalyticsProvider(url: url, providerDomains: self.config.providerDomains) else {
            logger.debug("Unknown destination. Ignoring request \(method) \(url)")
            return
        }

        if let isBodyIncomplete = trackRequest.isBodyIncomplete, isBodyIncomplete {
            logger.debug("Incomplete body. Ignoring request \(method) \(url)")
            return
        }

        // For Firebase protobuf payloads, build a synthetic JSON payload so the
        // adaptive sampling matcher can extract event names from it.
        let matchingPayload: String?
        if provider == "googleanalyticsfirebase",
           let rawPayload = trackRequest.post_payload,
           let eventNames = FirebasePayloadDecoder.extractEventNames(payload: rawPayload),
           let syntheticPayload = FirebasePayloadDecoder.buildSyntheticPayload(eventNames: eventNames) {
            matchingPayload = syntheticPayload
        } else {
            matchingPayload = trackRequest.post_payload
        }

        let sharedRequest = TrackingplanShared.Request(
            provider: provider,
            endpoint: trackRequest.endpoint,
            payload: matchingPayload
        )
        let result = session.evaluateSamplingDecision(request: sharedRequest)

        // Handle the sealed class result (SamplingResult is either Drop or Include)
        if let drop = result as? SamplingResult.Drop {
            logger.debug("Request dropped (reason: \(drop.reason.value)) \(method) \(url)")
            return
        }

        // After Drop check, result must be Include (sealed class has only two cases).
        // Defensive programming: if cast fails, sampling_rate is omitted and ingest logs it.
        let samplingResult = result as? SamplingResult.Include

        // Int() conversion needed: KMP Int becomes Int32 in Swift, but iOS uses Int
        let track = TrackingplanTrack(request: trackRequest,
                                      provider: provider,
                                      sampleRate: samplingResult.map { Int($0.effectiveSampleRate) },
                                      samplingMode: samplingResult?.samplingMode.value,
                                      sessionId: session.sessionId,
                                      config: self.config)

        if provider == TrackingplanNetworkManager.trackingplanProvider {
            self.trackQueue.enqueue(track)
        } else if config.batchSize == 1 {
            resolveNow(track: track)
        } else {
            // Append new tracks and check while timing
            self.trackQueue.enqueue(track)
            checkAndSend()
        }
    }

    func processPreQueue() {
        guard !preQueue.isEmpty else { return }
        guard let session = currentSession else {
            logger.debug("Cannot process preQueue: session not available")
            return
        }

        let requests = preQueue
        preQueue.removeAll()

        logger.debug("Processing \(requests.count) pre-queued requests...")

        for trackRequest in requests {
            processRequestWithSession(trackRequest: trackRequest, session: session)
        }

        logger.debug("Pre-queue processed")
    }
    
    private func getAnalyticsProvider(url:String, providerDomains: Dictionary<String, String>) -> String?{
        if url == "TRACKINGPLAN" {
            return TrackingplanNetworkManager.trackingplanProvider
        }
        return TrackingplanShared.UrlMatcher().matchProvider(providers: providerDomains, requestUrl: url)
    }

    // This method must be called from serialQueue
    func queueTrackingplanEvent(eventName: String) {
        guard let trackRequest = TrackingplanTrackRequest(eventName: eventName) else {
            logger.debug("Failed to queue Trackingplan \(eventName) event")
            return
        }
        logger.debug("Queued Trackingplan \(eventName) event")
        self.processRequest(trackRequest: trackRequest)
    }
    
    func queueSize() -> Int {
        return trackQueue.taskCount()
    }

    func clearQueue() {
        trackQueue.cleanUp()
    }

    func clearPreQueue() {
        preQueue.removeAll()
    }
    
    private func checkAndSend(forceSend: Bool = false) {
        
        let numTasks = trackQueue.taskCount()
        
        if numTasks == 0 {
            return
        }
        
        if !forceSend && numTasks < config.batchSize {
            startWatcher()
            return
        }
        
        // stopWatcher is called from resolveStackAndSend
        resolveStackAndSend()
    }
    
    private func startWatcher() {
        
        if watcher != nil { return }
        
        let watcher = DispatchWorkItem {
            self.watcher = nil
            self.logger.debug("Watcher timed out. Force batch send")
            self.checkAndSend(forceSend: true)
        }

        self.watcher = watcher
        self.logger.debug("Watcher started")
        
        serialQueue.asyncAfter(
            deadline: .now() + TrackingplanNetworkManager.batchTimeoutSecs,
            execute: watcher
        )
    }
    
    private func stopWatcher() {
        if watcher == nil { return }
        watcher?.cancel()
        watcher = nil
        self.logger.debug("Watcher stopped")
    }

    func resolveStackAndSend(completionHandler: ((Bool)->Void)? = nil) {
        stopWatcher()
        // TODO: Return tracks to the queue in case of error
        let rawQueue = self.trackQueue.retrieveRaw()
        sendTracks(tracks: rawQueue, completionHandler: completionHandler)
    }
    
    private func resolveNow(track: TrackingplanTrack) {
        guard let dictionary = track.dictionary else { return }
        sendTracks(tracks: [dictionary])
    }
    
    private func sendTracks(tracks: [[String: Any]], completionHandler: ((Bool)->Void)? = nil) {

        guard !tracks.isEmpty else {
            completionHandler?(false)
            return
        }

        // Log batch payload in debug mode for testing (before dryRun check so tests can verify)
        if config.debug,
           let jsonData = try? JSONSerialization.data(withJSONObject: tracks, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            logger.debug("Batch: \(jsonString)")
        }

        if config.dryRun {
            logger.debug("Dry run mode enabled. No tracks sent")
            completionHandler?(true)
            return
        }

        let startTime = ProcessInfo.processInfo.systemUptime

        var request = task()
        request.httpBody = try! JSONSerialization.data(withJSONObject: tracks, options: [])

        let sessionId = currentSession?.sessionId ?? ""

        let logger = self.logger
        
        var taskId: UIBackgroundTaskIdentifier = .invalid
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            defer {
                self.serialQueue.async {
                    Utils.endBackgroundTask(taskId)
                }
            }
            
            // TODO: Retry on error
            // Check for errors
            if let error = error {
                logger.error("Code: 500, Message: \(error)")
                if let completionHandler = completionHandler {
                    self.serialQueue.async {
                        completionHandler(false)
                    }
                }
                return
            }

            // Check if there is a response
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.debug("Invalid response")
                if let completionHandler = completionHandler {
                    self.serialQueue.async {
                        completionHandler(false)
                    }
                }
                return
            }

            // Check if the status code is in the success range (200-299)
            guard (200...299).contains(httpResponse.statusCode) else {
                logger.debug("HTTP response status code: \(httpResponse.statusCode)")
                if let completionHandler = completionHandler {
                    self.serialQueue.async {
                        completionHandler(false)
                    }
                }
                return
            }

            let elapsedTime = Int64((ProcessInfo.processInfo.systemUptime - startTime) * 1000)
            logger.debug("Batch sent (\(elapsedTime) ms)")

            self.serialQueue.async {
                if let currentSession = self.currentSession, !sessionId.isEmpty,
                   sessionId == currentSession.sessionId, currentSession.updateLastActivity() {
                    self.storage.saveSession(session: currentSession)
                    logger.debug("Last session activity updated and saved")
                }
                completionHandler?(true)
            }
        }

        // Request extra time in case the app goes to background while sending the request
        taskId = Utils.startBackgroundTask(name: "TrackingplanSend") { task.cancel() }

        logger.debug("Sending batch...")
        task.resume()
    }
    
    private func task() -> URLRequest {
        
        var endpoint = config.trackingplanEndpoint + config.tp_id
        
        if config.testing {
            let ts = Int64(Date().timeIntervalSince1970 * 1000)
            endpoint = "\(endpoint)?t=\(ts)"
        }
        
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    /// Downloads the raw ingest configuration JSON from the config endpoint.
    /// Does not parse the JSON - parsing is done by the caller (IngestConfigCache).
    /// - Returns: The raw JSON string, or nil if download fails
    func downloadIngestConfigRawSync() -> String? {

        guard let url = self.config.sampleRateURL() else {
            logger.debug("Error downloading config due to missing URL")
            return nil
        }

        let logger = self.logger
        var rawJson: String?
        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            defer {
                semaphore.signal()
            }

            guard let dataResponse = data, error == nil else {
                let errorMessage = error?.localizedDescription ?? "unknown error"
                logger.debug("Error downloading ingest config: \(errorMessage)")
                return
            }

            rawJson = String(data: dataResponse, encoding: .utf8)
        }

        task.resume()
        semaphore.wait()

        return rawJson
    }
}
