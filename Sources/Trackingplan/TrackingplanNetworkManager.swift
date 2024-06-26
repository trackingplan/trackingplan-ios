//
//  TrackingplanNetworkManager.swift
//  Trackingplan
//

import Foundation

class TrackingplanNetworkManager {
    
    fileprivate let config: TrackingplanConfig
    fileprivate var trackQueue: TrackingplanQueue = TrackingplanQueue.sharedInstance
    
    func task() -> URLRequest {
        let url = URL(string: self.config.trackingplanEndpoint + self.config.tp_id)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    fileprivate var didUpdate = false
    fileprivate var updatingSampleRate = false
    fileprivate var trackingQueue: DispatchQueue
    
    let logger: TrackingPlanLogger
    
    init(config: TrackingplanConfig, queue: DispatchQueue) {
        self.config = config
        self.trackingQueue = queue
        logger = TrackingplanManager.logger
        retrieveAndSampleRate(completionHandler: { complete in })
    }
    
    open func processRequest(urlRequest: URLRequest) {
        
        let url = urlRequest.url!.absoluteString
        
        if url.hasPrefix(config.trackingplanEndpoint) || url.hasPrefix(config.trackingplanConfigEndpoint) {
            // Ignore requests to trackingplan
            return
        }
        
        guard let provider = self.getAnalyticsProvider(url: urlRequest.url!.absoluteString, providerDomains: self.config.providerDomains) else {
            logger.debug(message: TrackingplanMessage.message("Unknown destination. Ignoring request \(url)"))
            return
        }
        
        let sampleRate = self.getSampleRate()
        
        if sampleRate == 0 {
            logger.debug(message: TrackingplanMessage.message("Unknown sampling rate. Ignoring request \(url)"))
            retrieveForEmptySampleRate()
            return
        }
        
        if !self.config.shouldTrackRequest(rate: sampleRate) {
            logger.debug(message: TrackingplanMessage.message("Tracking disabled. Ignoring request \(url)"))
            return
        }
        
        logger.debug(message: TrackingplanMessage.message("Processing request \(url)"))
        let track = TrackingplanTrack(urlRequest: urlRequest, provider: provider, sampleRate: sampleRate, config: self.config)
        
        if config.batchSize == 1 {
            resolveNow(track: track)
        } else {
            // Append new tracks and check while timing
            self.trackQueue.enqueue(track)
            self.didUpdate = true
            checkAndSend()
        }
    }
    
    private func resolveNow(track: TrackingplanTrack) {
        let raw = [track.dictionary!]
        var request = task()
        let session = URLSession.shared
        let jsonData = try! JSONSerialization.data(withJSONObject: raw, options: [])
        request.httpBody = jsonData
        
        let logger = self.logger
        let task =  session.dataTask(with: request) {data, response, error in
            // Check for errors
            if let error = error {
                logger.debug(message: TrackingplanMessage.error("500", "\(error)"))
                return
            }
            
            // Check if there is a response
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.debug(message: TrackingplanMessage.message("Invalid response"))
                return
            }
            
            // Check if the status code is in the success range (200-299)
            guard (200...299).contains(httpResponse.statusCode) else {
                logger.debug(message: TrackingplanMessage.message("HTTP response status code: \(httpResponse.statusCode)"))
                return
            }
            
            logger.debug(message: TrackingplanMessage.message("Batch sent"))
        }
        
        task.resume()
    }
    
    @objc private func checkAndSend() {
        if self.trackQueue.taskCount() >= self.config.batchSize  {
            resolveStackAndSend()
        }
    }
    
    
    @objc func resolveStackAndSend() {
        self.didUpdate = false
        let logger = self.logger
                
        trackingQueue.asyncAfter(deadline: TrackingplanQueue.delay) { [weak self] in
            
            guard !(self?.didUpdate ?? true), var request = self?.task(), let rawQueue = self?.trackQueue.retrieveRaw(), !rawQueue.isEmpty else {
                return
            }
            
            self?.trackQueue.cleanUp()
            
            let session = URLSession.shared
            request.httpBody = try! JSONSerialization.data(withJSONObject: rawQueue, options: [])
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                // Check for errors
                if let error = error {
                    logger.debug(message: TrackingplanMessage.error("500", "\(error)"))
                    return
                }
                
                // Check if there is a response
                guard let httpResponse = response as? HTTPURLResponse else {
                    logger.debug(message: TrackingplanMessage.message("Invalid response"))
                    return
                }
                
                // Check if the status code is in the success range (200-299)
                guard (200...299).contains(httpResponse.statusCode) else {
                    logger.debug(message: TrackingplanMessage.message("HTTP response status code: \(httpResponse.statusCode)"))
                    return
                }
                
                logger.debug(message: TrackingplanMessage.message("Batch sent"))
                
                // Cleanup queue when success only
                // let responseString = String(data: data, encoding: .utf8)
                // print("responseString = \(String(describing: responseString))")
                
            }
            
            task.resume()
        }
    }
    
    private func getAnalyticsProvider(url:String, providerDomains: Dictionary<String, String>) -> String?{
        for (pattern, provider) in providerDomains {
            if url.contains(pattern){
                return provider
            }
        }
        return nil
    }
    
    private func setSampleRate(sampleRate: Int){
        let sampleData = TrackingplanSampleRate(
            sampleRate: sampleRate,
            sampleRateTimestamp: TrackingplanConfig.getCurrentTimestamp()
        )
        UserDefaults.standard.encode(for: sampleData, using: UserDefaultKey.sampleRate.rawValue)
        UserDefaultsHelper.setData(value: Int(TrackingplanConfig.getCurrentTimestamp()), key: .sampleRateTimestamp)
    }
    
    private func getSampleRate() -> Int{
        
        if config.ignoreSampling {
            return 1
        }
        
        guard let currentSampleRate = UserDefaults.standard.decode(for: TrackingplanSampleRate.self, using: UserDefaultKey.sampleRate.rawValue) else {
            return 0
        }
        
        let sampleRate = currentSampleRate.validSampleRate()
        return sampleRate
    }
    
    func retrieveForEmptySampleRate() {
        // retry to download config after 5 minutes
        let retryDownloadAfterSeconds = 300
        if let emptySampleRateTimeStamp = UserDefaultsHelper.getData(type: Int.self, forKey: .sampleRateTimestamp), Int(TrackingplanConfig.getCurrentTimestamp()) - emptySampleRateTimeStamp > retryDownloadAfterSeconds &&  UserDefaultsHelper.getData(type: TrackingplanSampleRate.self, forKey: .sampleRate) != nil {
            retrieveAndSampleRate { _ in}
        }
    }
    func retrieveAndSampleRate(completionHandler:@escaping (Bool)->Void){
        
        if (self.updatingSampleRate) {
            return
        }
        
        if self.getSampleRate() != 0 {
            return
        }
        
        let logger = self.logger
        
        logger.debug(message: TrackingplanMessage.message("Sample rate expired. Refresh needed."))
        
        guard let url = self.config.sampleRateURL() else {
            logger.debug(message: TrackingplanMessage.message("Error downloading sample rate due to missing URL."))
            return
        }
        
        self.updatingSampleRate = true
        
        let task = URLSession.shared.dataTask(with: url) {[weak self](data, response, error) in
            
            guard let dataResponse = data, error == nil else {
                let errorMessage = error?.localizedDescription ?? "unknown error"
                logger.debug(message: TrackingplanMessage.message("Error downloading sample rate \(errorMessage)"))
                self?.updatingSampleRate = false
                UserDefaultsHelper.setData(value: Int(TrackingplanConfig.getCurrentTimestamp()), key: .sampleRateTimestamp)
                completionHandler(false)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: AnyObject]
                
                var sampleRate = 0
                if let defaultSampleRate = json["sample_rate"] as? Int{
                    sampleRate = defaultSampleRate
                }
                
                if let environmentSampleRate = json["environment_rates"]?[self?.config.environment ?? "" as String] as? Int{
                    sampleRate = environmentSampleRate
                }
                
                self?.setSampleRate(sampleRate: sampleRate)
                self?.updatingSampleRate = false
                completionHandler(true)
                
            } catch let error {
                if let httpResponse = response as? HTTPURLResponse {
                    logger.debug(message: TrackingplanMessage.error(String(httpResponse.statusCode), error.localizedDescription))
                }
                self?.updatingSampleRate = false
                UserDefaultsHelper.setData(value: Int(TrackingplanConfig.getCurrentTimestamp()), key: .sampleRateTimestamp)
                completionHandler(false)
            }
        }
        
        task.resume()
    }
}
