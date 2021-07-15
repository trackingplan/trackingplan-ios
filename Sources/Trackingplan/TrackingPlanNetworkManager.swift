//
//  File.swift
//  
//
//  Created by Juan Pedro Lozano Baño on 5/7/21.
//

import Foundation

open class TrackingPlanNetworkManager {
    
    fileprivate let config: TrackingplanConfig
    fileprivate var trackQueue: TrackingPlanQueue = TrackingPlanQueue()

    func task() -> URLRequest {
        let url = URL(string: self.config.trackingplanEndpoint)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    fileprivate var didUpdate = false
    fileprivate var updatingSampleRate = false
    fileprivate var trackingQueue: DispatchQueue

    init(config: TrackingplanConfig, queue: DispatchQueue) {
        self.config = config
        self.trackingQueue = queue
        retrieveAndSampleRate(completionHandler: { complete in })
    }
    
    open func processRequest(urlRequest: URLRequest) {
        guard let provider = self.getAnalyticsProvider(url: urlRequest.url!.absoluteString, providerDomains: self.config.providerDomains) else {
            //Log
            return
        }
        
        //Sampling
        let sampleRate = self.getSampleRate()
        if(sampleRate == 0){ // sample rate is unknown
            retrieveForEmptySampleRate() 
        }else if (self.config.shouldUpdate(rate: sampleRate)) { //Rolling with sampling
                //Append new tracks and check while timing
                let track = TrackingPlanTrack(urlRequest: urlRequest, provider: provider, sampleRate: sampleRate, config: self.config)
                self.trackQueue.enqueue(track)
                self.didUpdate = true
                checkAndSend()
        }
    }
    
    private func checkAndSend() {
        guard self.trackQueue.taskCount() >= self.config.batchSize else {
            return
        }
        self.didUpdate = false
        trackingQueue.asyncAfter(deadline: TrackingPlanQueue.delay) { [weak self] in
            guard !(self?.didUpdate ?? true), var request = self?.task(), let rawQueue = self?.trackQueue.retrieveRaw(), !rawQueue.isEmpty else {
                return
            }
            
            let session = URLSession.shared
            let jsonData = try! JSONSerialization.data(withJSONObject: rawQueue, options: [])
            request.httpBody = jsonData
            let task =  session.dataTask(with: request) {data, response, error in
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      error == nil else {
                    //LOG ERROR
                    print("error", error ?? "Unknown error")
                    return
                }
                guard (200 ... 299) ~= response.statusCode else {
                    //LOG ERROR
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
                //Cleanup queue when success only
                let responseString = String(data: data, encoding: .utf8)
                self?.trackQueue.cleanUp()
                print("responseString = \(String(describing: responseString))")
                
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
        let sampleData = TrackingPlanSampleRate(
            sampleRate: sampleRate,
            sampleRateTimestamp: TrackingplanConfig.getCurrentTimestamp())
        UserDefaults.standard.encode(for: sampleData, using: UserDefaultKey.sampleRate.rawValue)
        UserDefaultsHelper.setData(value: Int(TrackingplanConfig.getCurrentTimestamp()), key: .sampleRateTimestamp)
    }
    
    private func getSampleRate() -> Int{
        guard let currentSampleRate = UserDefaults.standard.decode(for: TrackingPlanSampleRate.self, using: UserDefaultKey.sampleRate.rawValue) 
        else {
            return 0
        }

        let sampleRate = currentSampleRate.validSampleRate()
        return sampleRate
    }

    func retrieveForEmptySampleRate() {
        // retry to download config after X seconds
        let retryDownloadAfterSeconds = 3600
        if let emptySampleRateTimeStamp = UserDefaultsHelper.getData(type: Int.self, forKey: .sampleRateTimestamp), Int(TrackingplanConfig.getCurrentTimestamp()) - emptySampleRateTimeStamp > retryDownloadAfterSeconds &&  UserDefaultsHelper.getData(type: TrackingPlanSampleRate.self, forKey: .sampleRate) != nil {
            retrieveAndSampleRate { _ in}
        } 
    }
    
    func retrieveAndSampleRate(completionHandler:@escaping (Bool)->Void){
        
        if(self.updatingSampleRate) {
            return
        }
        let sampleRate = self.getSampleRate()
        
        if(sampleRate == 0) {
            guard let url = self.config.sampleRateURL() else {
                return
            }
            self.updatingSampleRate = true
            let task = URLSession.shared.dataTask(with: url) {[weak self](data, response, error) in
                guard let dataResponse = data,
                        error == nil else {
                            print(error?.localizedDescription ?? "Response Error")
                            return 
                        }
                    do {
                        let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: Int]
                        let sampleRate = Int(json["sample_rate"]!)
                        self?.setSampleRate(sampleRate: sampleRate)
                        self?.updatingSampleRate = false
                        completionHandler(true)

                    } catch let error {
                        if let httpResponse = response as? HTTPURLResponse {
                            Logger.debug(message: TrackingPlanMessage.error(String(httpResponse.statusCode), error.localizedDescription))
                           }

                        self?.updatingSampleRate = false
                        UserDefaultsHelper.setData(value: Int(TrackingplanConfig.getCurrentTimestamp()), key: .sampleRateTimestamp)
                        completionHandler(false)
                    }
            }
            task.resume()
        }
    }
}
