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
    fileprivate let lock = ReadWriteLock(label: "com.trackingPlan.lock")
    private var trackingQueue: DispatchQueue

    init(config: TrackingplanConfig, queue: DispatchQueue) {
        self.config = config
        self.trackingQueue = queue
    }

    open func archive() {
        lock.read {
            self.trackQueue.archive()
        }
    }

    open func unarchive() {
        lock.write {
            self.trackQueue.unarchive()
        }
    }
    
    open func processRequest(urlRequest: URLRequest) {
        guard let provider = self.getAnalyticsProvider(url: urlRequest.url!.absoluteString, providerDomains: self.config.providerDomains) else {
            //Log
            return
        }
        
        let sampleRate = self.getSampleRate()
        if(sampleRate == 0){
            self.updateSampleRateAndProcessQueue()
        }
        let rolledDice = (Float(arc4random()) / Float(UInt32.max))
        let rate = 1 / Float(sampleRate)
        if(!self.config.ignoreSampling && rolledDice > rate ){
        }
        
        //Append new tracks and check while timing
        let track = TrackingPlanTrack(urlRequest: urlRequest, provider: provider, sampleRate: sampleRate, config: self.config)
        self.trackQueue.enqueue(track)
        self.didUpdate = true
        checkAndSend()
        
    }
    
    private func checkAndSend() {
        guard self.trackQueue.taskCount() >= self.config.batchSize else {
            return
        }
        
        self.didUpdate = false
        trackingQueue.asyncAfter(deadline: TrackingPlanQueue.delay) { [weak self] in
            guard !(self?.didUpdate ?? true), var request = self?.task(), let rawQueue = self?.trackQueue.retrieveRaw() else {
                //LOG ERROR
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

                        let responseString = String(data: data, encoding: .utf8)
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
        let value = String(sampleRate)+"|"+String(self.getCurrentTS())
        UserDefaults.standard.set(value, forKey: "trackingplanSampleRate")
    }
    
    private func getSampleRate() -> Int{
        let sampleRateWithTS = UserDefaults.standard.string(forKey: "trackingplanSampleRate")
        if (sampleRateWithTS == nil){
            return 0
        }
        
        let parts = sampleRateWithTS!.split(separator: "|")
        let sampleRate = Int(parts[0]) ?? 0
        let ts = Int(parts[1]) ?? 0
        let currentTS = self.getCurrentTS()
        if(ts+86400 > currentTS ){
            return sampleRate
        } else {
            return 0
        }
    }
    
    private func getCurrentTS() -> Int{
        return Int(round(NSDate().timeIntervalSince1970))
    }
    
    private func getConfigUrl() -> String{
        return self.config.trackingplanConfigEndpoint + "config-" + self.config.tpId + ".json";
    }
    
    private func updateSampleRateAndProcessQueue(){
//        self.log(string:"---START UPDATE")
//        if(self.updatingSampleRate) {
//            self.log(string:"***ALREADY UPDATING")
//            return
//        }
//        self.updatingSampleRate = true; // TODO: is this shitty lock ok?
//        let sampleRate = self.getSampleRate()
//        if(sampleRate == 0) {
//
//            let url = URL(string: self.getConfigUrl())!
//
//            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//                guard let dataResponse = data,
//                          error == nil else {
//                          print(error?.localizedDescription ?? "Response Error")
//                          return }
//                    do{
//                         let json = try JSONSerialization.jsonObject(with: dataResponse
//                        , options: []) as! [String: Int]
//                        let sampleRate = Int(json["sample_rate"]!) //Response result
//                        self.setSampleRate(sampleRate: sampleRate)
//                        self.updatingSampleRate = false
//                        self.processQueue()
//                     } catch let error {
//                        print("Processing config response error", error)
//                        self.updatingSampleRate = false
//                   }
//
//
//
//            }
//            task.resume()
//        }
    }
}
