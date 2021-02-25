//
//  TrackingPlanRequestHandler.swift
//  Trackingplan
//
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
        let alternateRequest = URLRequestFactory().createURLRequest(originalUrlRequest: urlRequest)
        _ = processRequest(urlRequest: alternateRequest)
    }
    
    public func processRequest(urlRequest: URLRequest) -> Bool{
        let provider = self.getAnalyticsProvider(url: urlRequest.url!.absoluteString, providerDomains: self.options["providerDomains"] as! Dictionary<String, String>)
        
        if(provider == nil){
            return false
        }
        if (self.isDebug()) { print("FOUND REQUEST TO "+provider!) }
        
        let sampleRate = self.getSampleRate()
        if(sampleRate == 0){
            if (self.isDebug()) { print("APPEND TO QUEUE "+String(self.queue.count)) }
            self.queue.append(urlRequest)
            self.updateSampleRateAndProcessQueue()
            return false
        }
        let rolledDice = (Float(arc4random()) / Float(UInt32.max))
        let rate = 1 / Float(sampleRate)
        if((self.options["ignoreSampling"] as! Bool) == false && rolledDice > rate ){
            if (self.isDebug()) { print("===BAD LUCK REQUEST "+String(rolledDice) + " > " + String(rate)) }
            return true;
        }
        
        self.sendToTrackingPlan(urlRequest: urlRequest, provider: provider!, sampleRate: sampleRate)
        
        return true
    }
    
    private func isDebug() -> Bool {
        return (self.options["debug"] as! Bool == true)
    }
    
    
    private func sendToTrackingPlan(urlRequest: URLRequest, provider: String, sampleRate: Int){
        let raw_track = self.createRawTrack(urlRequest:urlRequest, provider: provider, sampleRate: sampleRate)

        let session = URLSession.shared
        let url = URL(string: self.options["trackingplanEndpoint"] as! String)!
        //let url = URL(string: "https://enxzt9ro1z1t9.x.pipedream.net")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: raw_track, options: [])
        request.httpBody = jsonData
        let task = session.dataTask(with: request) { data, response, error in
            if(self.isDebug()){
                guard let data = data,
                        let response = response as? HTTPURLResponse,
                        error == nil else {                                              // check for fundamental networking error
                        print("error", error ?? "Unknown error")
                        return
                    }

                    guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                        print("statusCode should be 2xx, but is \(response.statusCode)")
                        print("response = \(response)")
                        return
                    }

                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString)")
            }
        }

        task.resume()
       
        
    }
    
    private func processQueue(){
        while (!self.queue.isEmpty) {
            if (self.isDebug()){print("UNQUEUE "+String(self.queue.count))}
            let urlRequest = self.queue.popLast()
            _ = self.processRequest(urlRequest: urlRequest!)
            
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
        if (self.isDebug()){print(">>>SET SAMPLE RATE A "+String(sampleRate))}
        let value = String(sampleRate)+"|"+String(self.getCurrentTS())
        UserDefaults.standard.set(value, forKey: "trackingplanSampleRate")
    }
    
    public func getSampleRate() -> Int{
        let sampleRateWithTS = UserDefaults.standard.string(forKey: "trackingplanSampleRate")
        if (sampleRateWithTS == nil){
            return 0
        }
        
        let parts = sampleRateWithTS!.split(separator: "|")
        let sampleRate = Int(parts[0]) ?? 0
        let ts = Int(parts[1]) ?? 0
        if (self.isDebug()){print("GET SAMPLE RATE "+String(sampleRate))}
        let currentTS = self.getCurrentTS()
        if(ts+50 > currentTS ){
            return sampleRate
        } else {
            if (self.isDebug()){print("SAMPLE RATE EVICTED")}
            return 0
        }
    }
    
    private func getCurrentTS() -> Int{
        return Int(round(NSDate().timeIntervalSince1970))
    }
    
    public func updateSampleRateAndProcessQueue(){
        if (self.isDebug()){print("---START UPDATE")}
        if(self.updatingSampleRate) {
            if (self.isDebug()){print("***ALREADY UPDATING")}
            return
        }
        self.updatingSampleRate = true; // TODO: is this shitty lock ok?
        let sampleRate = self.getSampleRate()
        if(sampleRate == 0) {
            
            let url = URL(string: self.options["trackingplanConfigEndpoint"] as! String)!
            
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data,
                        let response = response as? HTTPURLResponse,
                        error == nil else {                                              // check for fundamental networking error
                    if(self.isDebug()) {
                        print("error downoading sample rate", error ?? "Unknown error")}
                        return
                    }

                    guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                        if(self.isDebug()) {
                            print("downloading sample rate statusCode should be 2xx, but is \(response.statusCode)")
                            print("response = \(response)")
                        }
                        return
                    }

                    let responseString = String(data: data, encoding: .utf8)
                    if(self.isDebug()) {
                        print("sample rate string = \(responseString)")
                    }
                
                
                self.setSampleRate(sampleRate: 4)
                self.updatingSampleRate = false;
                self.processQueue()
            }
            task.resume()
        }
    }
    
    private func log(string: String, force: Bool = false){
        if(self.isDebug() || force == false){
            print(string);
        }
    }
    
    private func createRawTrack(urlRequest:URLRequest, provider: String, sampleRate: Int) -> Dictionary<String, Any>{
             return [
            // Normalized provider name (extracted from domain/regex => provider hash table).
            "provider": provider,
            
            "request": [
                // The original provider endpoint URL
                "endpoint": urlRequest.url!.absoluteString,
                // The request method. It’s not just POST & GET, but the info needed to inform the parsers how to decode the payload within that provider, e.g. Beacon.
                "method": urlRequest.httpMethod as Any,
                // The payload, in its original form. If it’s a POST request, the raw payload, if it’s a GET, the querystring (are there other ways?).
                "post_payload": urlRequest.getHttpBody() as Any,
            ] ,
            "context": [
                "app_version_long": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
                "app_name": Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String,
                "app_build_number": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
                
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


class URLRequestFactory {
    public func createURLRequest(originalUrlRequest: URLRequest) -> URLRequest {
 
        var redirectedRequest = URLRequest(url: originalUrlRequest.url!)
        if let _ = originalUrlRequest.httpBodyStream,
            let httpBodyStreamData = originalUrlRequest.getHttpBodyStreamData() {
            redirectedRequest.httpBody = httpBodyStreamData
        } else {
            redirectedRequest.httpBody = originalUrlRequest.httpBody
        }
        redirectedRequest.httpMethod = originalUrlRequest.httpMethod!
        redirectedRequest.allHTTPHeaderFields = originalUrlRequest.allHTTPHeaderFields
        redirectedRequest.cachePolicy = originalUrlRequest.cachePolicy
        return redirectedRequest
    }
}
