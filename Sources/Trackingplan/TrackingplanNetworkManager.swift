//
//  TrackingplanNetworkManager.swift
//  Trackingplan
//

import Foundation
import UIKit


class TrackingplanNetworkManager {

    private static let trackingplanProvider = "trackingplan"
    
    private static let batchTimeoutSecs: TimeInterval = 30.0
    
    private let config: TrackingplanConfig
    var currentSession: TrackingplanSession?
    private let trackQueue: TrackingplanQueue
    private let logger: TrackingPlanLogger
    private let serialQueue: DispatchQueue
    private let storage: Storage
    private var watcher: DispatchWorkItem?

    init(config: TrackingplanConfig, serialQueue: DispatchQueue, storage: Storage) {
        self.config = config
        self.serialQueue = serialQueue
        self.storage = storage
        logger = TrackingplanManager.logger
        trackQueue = TrackingplanQueue.sharedInstance
    }

    // This method must be called from serialQueue
    func processRequest(urlRequest: URLRequest) {
        let trackRequest = TrackingplanTrackRequest(urlRequest: urlRequest)
        processRequest(trackRequest: trackRequest)
    }

    private func processRequest(trackRequest: TrackingplanTrackRequest) {

        let url = trackRequest.endpoint

        if url.hasPrefix(config.trackingplanEndpoint) || url.hasPrefix(config.trackingplanConfigEndpoint) {
            // Ignore requests to trackingplan
            return
        }

        guard let provider = self.getAnalyticsProvider(url: url, providerDomains: self.config.providerDomains) else {
            logger.debug(message: TrackingplanMessage.message("Unknown destination. Ignoring request \(url)"))
            return
        }

        // TODO: Queue requests while the session is not available yet
        guard let currentSession = currentSession else {
            logger.debug(message: TrackingplanMessage.message("Unknown session. Ignoring request \(url)"))
            return
        }

        if !currentSession.trackingEnabled {
            logger.debug(message: TrackingplanMessage.message("Tracking disabled for current session. Ignoring request \(url)"))
            return
        }

        if provider != TrackingplanNetworkManager.trackingplanProvider {
            logger.debug(message: TrackingplanMessage.message("Processing request \(url)"))
        }

        let track = TrackingplanTrack(request: trackRequest,
                                      provider: provider,
                                      sampleRate: currentSession.samplingRate,
                                      sessionId: currentSession.sessionId,
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
    
    private func getAnalyticsProvider(url:String, providerDomains: Dictionary<String, String>) -> String?{
        if url == "TRACKINGPLAN" {
            return TrackingplanNetworkManager.trackingplanProvider
        }
        for (pattern, provider) in providerDomains {
            if url.contains(pattern){
                return provider
            }
        }
        return nil
    }

    // This method must be called from serialQueue
    func queueTrackingplanEvent(eventName: String) {
        guard let trackRequest = TrackingplanTrackRequest(eventName: eventName) else {
            logger.debug(message: TrackingplanMessage.message("Failed to queue Trackingplan \(eventName) event"))
            return
        }
        logger.debug(message: TrackingplanMessage.message("Queued Trackingplan \(eventName) event"))
        self.processRequest(trackRequest: trackRequest)
    }
    
    func queueSize() -> Int {
        return trackQueue.taskCount()
    }

    func clearQueue() {
        trackQueue.cleanUp()
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
            self.logger.debug(message: TrackingplanMessage.message("Watcher timed out. Force batch send"))
            self.checkAndSend(forceSend: true)
        }
        
        self.watcher = watcher
        self.logger.debug(message: TrackingplanMessage.message("Watcher started"))
        
        serialQueue.asyncAfter(
            deadline: .now() + TrackingplanNetworkManager.batchTimeoutSecs,
            execute: watcher
        )
    }
    
    private func stopWatcher() {
        if watcher == nil { return }
        watcher?.cancel()
        watcher = nil
        self.logger.debug(message: TrackingplanMessage.message("Watcher stopped"))
    }

    func resolveStackAndSend(completionHandler: ((Bool)->Void)? = nil) {
        stopWatcher()
        // TODO: Return tracks to the queue in case of error
        let rawQueue = self.trackQueue.retrieveRaw()
        sendTracks(tracks: rawQueue, completionHandler: completionHandler)
    }
    
    private func resolveNow(track: TrackingplanTrack) {
        sendTracks(tracks: [track.dictionary!])
    }
    
    private func sendTracks(tracks: [[String: Any]], completionHandler: ((Bool)->Void)? = nil) {
        
        guard !tracks.isEmpty else {
            completionHandler?(false)
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
                logger.debug(message: TrackingplanMessage.error("500", "\(error)"))
                if let completionHandler = completionHandler {
                    self.serialQueue.async {
                        completionHandler(false)
                    }
                }
                return
            }

            // Check if there is a response
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.debug(message: TrackingplanMessage.message("Invalid response"))
                if let completionHandler = completionHandler {
                    self.serialQueue.async {
                        completionHandler(false)
                    }
                }
                return
            }

            // Check if the status code is in the success range (200-299)
            guard (200...299).contains(httpResponse.statusCode) else {
                logger.debug(message: TrackingplanMessage.message("HTTP response status code: \(httpResponse.statusCode)"))
                if let completionHandler = completionHandler {
                    self.serialQueue.async {
                        completionHandler(false)
                    }
                }
                return
            }

            let elapsedTime = Int64((ProcessInfo.processInfo.systemUptime - startTime) * 1000)
            logger.debug(message: TrackingplanMessage.message("Batch sent (\(elapsedTime) ms)"))
            
            self.serialQueue.async {
                if let currentSession = self.currentSession, !sessionId.isEmpty,
                   sessionId == currentSession.sessionId, currentSession.updateLastActivity() {
                    self.storage.saveSession(session: currentSession)
                    logger.debug(message: TrackingplanMessage.message("Last session activity updated and saved"))
                }
                completionHandler?(true)
            }
        }
        
        // Request extra time in case the app goes to background while sending the request
        taskId = Utils.startBackgroundTask(name: "TrackingplanSend") { task.cancel() }

        logger.debug(message: TrackingplanMessage.message("Sending batch..."))
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

    func downloadSamplingRateSync() -> Int? {

        guard let url = self.config.sampleRateURL() else {
            logger.debug(message: TrackingplanMessage.message("Error downloading sample rate due to missing URL"))
            return nil
        }

        let logger = self.logger

        var sampleRate: Int?

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: url) {[weak self](data, response, error) in

            defer {
                semaphore.signal()
            }

            guard let dataResponse = data, error == nil else {
                let errorMessage = error?.localizedDescription ?? "unknown error"
                logger.debug(message: TrackingplanMessage.message("Error downloading sampling rate: \(errorMessage)"))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: AnyObject]

                if let environmentSampleRate = json["environment_rates"]?[self?.config.environment ?? "" as String] as? Int{
                    sampleRate = environmentSampleRate
                    return
                }

                if let defaultSampleRate = json["sample_rate"] as? Int{
                    sampleRate = defaultSampleRate
                    return
                }
            } catch let error {
                let errorMessage = error.localizedDescription
                logger.debug(message: TrackingplanMessage.message("Error downloading sampling rate: \(errorMessage)"))
            }
        }

        task.resume()

        semaphore.wait()

        return sampleRate
    }
}
