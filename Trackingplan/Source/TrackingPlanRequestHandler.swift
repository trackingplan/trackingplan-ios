//
//  TrackingPlanRequestHandler.swift
//  Trackingplan
//
//  Created by José Luis Pérez on 24/2/21.
//

import Foundation
import NetworkInterceptor

public class TrackingPlanRequestHandler: SniffableRequestHandler {
    private var options: Dictionary<String, Any?>
    private var queue: [URLRequest] = []
    private var updatingSampleRate = false
    
    public init(options: Dictionary<String, Any?>){
        self.options = options
        
    }
    
    // This function name cannot be changed, it's a convention from NetworkInterceptor
    public func sniffRequest(urlRequest: URLRequest) {
        _ = processRequest(urlRequest: urlRequest)
    }
    
    public func processRequest(urlRequest: URLRequest) -> Bool{
        let provider = self.getAnalyticsProvider(url: urlRequest.url!.absoluteString, providerDomains: self.options["providerDomains"] as! Dictionary<String, String>)
        
        if(provider == nil){
            return false
        }
        print("FOUND REQUEST TO "+provider!)
        
        let sampleRate = self.getSampleRate()
        if(sampleRate == 0){
            print("APPEND TO QUEUE "+String(self.queue.count))
            self.queue.append(urlRequest)
            self.updateSampleRateAndProcessQueue()
            return false
        }
        let rolledDice = (Float(arc4random()) / Float(UInt32.max))
        let rate = 1 / Float(sampleRate)
        if((self.options["ignoreSampling"] as! Bool) == false && rolledDice > rate ){
            print("===BAD LUCK REQUEST "+String(rolledDice) + " > " + String(rate))
            return true;
        }
        
        self.sendToTrackingPlan(urlRequest: urlRequest, provider: provider!, sampleRate: sampleRate)
        
        return true
    }
    
    
    
    private func sendToTrackingPlan(urlRequest: URLRequest, provider: String, sampleRate: Int){
        let raw_track = self.createRawTrack(urlRequest:urlRequest, provider: provider, sampleRate: sampleRate)

        let session = URLSession.shared
        let url = URL(string: self.options["trackingplanEndpoint"] as! String)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: raw_track, options: [])
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            if(self.options["debug"] as Bool == true){
                print("APPLAUSE: RECIBIDA RESPUESTA AMIGO")
            }
        }

        task.resume()
       
        
    }
    
    private func processQueue(){
        while (!self.queue.isEmpty) {
            print("UNQUEUE "+String(self.queue.count))
            let urlRequest = self.queue.popLast()
            _ = self.processRequest(urlRequest: urlRequest!)
            sleep(1)
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
    public func setSampleRate(sampleRate: Int){
        print(">>>SET SAMPLE RATE A "+String(sampleRate))
        let value = String(sampleRate)+"|"+String(self.getCurrentTS())
        
        UserDefaults.standard.set(value, forKey: "trackingplanSampleRate")
        //UserDefaults.standard.removeObject(forKey: "TrackingplanSampleRate")
    }
    
    public func getSampleRate() -> Int{
        let sampleRateWithTS = UserDefaults.standard.string(forKey: "trackingplanSampleRate")
        if (sampleRateWithTS == nil){
            return 0
        }
        
        let parts = sampleRateWithTS!.split(separator: "|")
        let sampleRate = Int(parts[0]) ?? 0
        let ts = Int(parts[1]) ?? 0
        print("GET SAMPLE RATE "+String(sampleRate))
        let currentTS = self.getCurrentTS()
        if(ts+50 > currentTS ){
            return sampleRate
        } else {
            print("SAMPLE RATE EVICTED")
            return 0
        }
    }
    
    private func getCurrentTS() -> Int{
        return Int(round(NSDate().timeIntervalSince1970))
    }
    
    public func updateSampleRateAndProcessQueue(){
        print("---START UPDATE")
        if(self.updatingSampleRate) {
            print("***ALREADY UPDATING")
            return
        }
        self.updatingSampleRate = true;
        let sampleRate = self.getSampleRate()
        if(sampleRate == 0) {
            
            let url = URL(string: "http://www.stackoverflow.com")!
            
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                self.setSampleRate(sampleRate: 4)
                self.updatingSampleRate = false;
                self.processQueue()
            }
            task.resume()
        }
    }
    
    private func createRawTrack(urlRequest:URLRequest, provider: String, sampleRate: Int) -> Dictionary <String, Any>{
        return [
            // Normalized provider name (extracted from domain/regex => provider hash table).
            "provider": provider,
            
            "request": [
                // The original provider endpoint URL
                "endpoint": urlRequest.url as Any,
                // The request method. It’s not just POST & GET, but the info needed to inform the parsers how to decode the payload within that provider, e.g. Beacon.
                "method": urlRequest.httpMethod as Any,
                // The payload, in its original form. If it’s a POST request, the raw payload, if it’s a GET, the querystring (are there other ways?).
                "post_payload": urlRequest.getHttpBody() as Any,
            ],
            "context": [
                "app_version_long": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
                "app_name": Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String,
                "app_build_numnber": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
                
                // Information that is extracted in run time that can be useful. IE. UserAgent, URL, etc. it varies depending on the platform. Can we standardize it?
            ],
            // A key that identifies the customer. It’s written by the developer on the SDK initialization.
            "tp_id": self.options["tpId"] as Any,
            // An optional alias that identifies the source. It’s written by the developer on the SDK initialization.
            "source_alias": self.options["sourceAlias"] as Any,
            // An optional environment. It’s written by the developer on the SDK initialization. Useful for the developer testing. Can be "PRODUCTION" or "TESTING".
            "environment": self.options["environment"]!!,
            // The used sdk. It’s known by the sdk itself.
            "sdk": Trackingplan.sdk,
            // The SDK version, useful for implementing different parsing strategies. It’s known by the sdk itself.
            "sdk_version": Trackingplan.sdkVersion,
            // The rate at which this specific track has been sampled.
            "sampling_rate": sampleRate,
            // Debug mode. Makes every request return and console.log the parsed track.
            "debug": self.options["debug"] as Any
        ]
        
        
        
        
    }
    
}

