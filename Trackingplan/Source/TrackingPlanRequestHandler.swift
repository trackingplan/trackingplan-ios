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
    private var config: TrackingplanConfig
    private var queue: [URLRequest] = []
    private var updatingSampleRate = false
    
    public init(config: TrackingplanConfig){
        self.config = config
    }
    
    // This function name cannot be changed, it's a convention from NetworkInterceptor
    public func sniffRequest(urlRequest: URLRequest) {
        let alternateRequest = URLRequestFactory().createURLRequest(originalUrlRequest: urlRequest)
        _ = processRequest(urlRequest: alternateRequest)
    }
    
    private func processRequest(urlRequest: URLRequest) -> Bool{
        let provider = self.getAnalyticsProvider(url: urlRequest.url!.absoluteString, providerDomains: self.config.providerDomains)
        
        if(provider == nil){
            return false
        }
        self.log(string:"FOUND REQUEST TO "+provider!)
        
        let sampleRate = self.getSampleRate()
        if(sampleRate == 0){
            self.log(string:"APPEND TO QUEUE "+String(self.queue.count))
            self.queue.append(urlRequest)
            self.updateSampleRateAndProcessQueue()
            return false
        }
        let rolledDice = (Float(arc4random()) / Float(UInt32.max))
        let rate = 1 / Float(sampleRate)
        if(!self.config.ignoreSampling && rolledDice > rate ){
            self.log(string:"===BAD LUCK REQUEST "+String(rolledDice) + " > " + String(rate))
            return true;
        }
        
        self.sendToTrackingPlan(urlRequest: urlRequest, provider: provider!, sampleRate: sampleRate)
        
        return true
    }
    
    private func isDebug() -> Bool {
        return (self.config.debug)
    }
    
    
    private func sendToTrackingPlan(urlRequest: URLRequest, provider: String, sampleRate: Int){
        let raw_track = self.createRawTrack(urlRequest:urlRequest, provider: provider, sampleRate: sampleRate)

        let session = URLSession.shared
        let url = URL(string: self.config.trackingplanEndpoint)
        //let url = URL(string: "https://enxzt9ro1z1t9.x.pipedream.net")!
        var request = URLRequest(url: url!)
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
                print("responseString = \(String(describing: responseString))")
            }
        }

        task.resume()
       
        
    }
    
    private func processQueue(){
        while (!self.queue.isEmpty) {
            self.log(string:"UNQUEUE "+String(self.queue.count))
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
    private func setSampleRate(sampleRate: Int){
        self.log(string:">>>SET SAMPLE RATE A "+String(sampleRate))
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
        self.log(string:"GET SAMPLE RATE "+String(sampleRate))
        let currentTS = self.getCurrentTS()
        if(ts+86400 > currentTS ){
            return sampleRate
        } else {
            self.log(string:"SAMPLE RATE EVICTED")
            return 0
        }
    }
    
    private func getCurrentTS() -> Int{
        return Int(round(NSDate().timeIntervalSince1970))
    }
    
    private func updateSampleRateAndProcessQueue(){
        self.log(string:"---START UPDATE")
        if(self.updatingSampleRate) {
            self.log(string:"***ALREADY UPDATING")
            return
        }
        self.updatingSampleRate = true; // TODO: is this shitty lock ok?
        let sampleRate = self.getSampleRate()
        if(sampleRate == 0) {
            
            let url = URL(string: self.getConfigUrl())!
            
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let dataResponse = data,
                          error == nil else {
                          print(error?.localizedDescription ?? "Response Error")
                          return }
                    do{
                         let json = try JSONSerialization.jsonObject(with: dataResponse
                        , options: []) as! [String: Int]
                        let sampleRate = Int(json["sample_rate"]!) //Response result
                        self.setSampleRate(sampleRate: sampleRate)
                        self.updatingSampleRate = false
                        self.processQueue()
                     } catch let error {
                        print("Processing config response error", error)
                        self.updatingSampleRate = false
                   }
                
                

            }
            task.resume()
        }
    }
    
    func log(string: String, force: Bool? = false){
        if(self.config.debug || force == true){
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
                "tp_id": self.config.tpId,
            // An optional alias that identifies the source. It’s written by the developer on the SDK initialization.
                "source_alias": self.config.sourceAlias,
            // An optional environment. It’s written by the developer on the SDK initialization. Useful for the developer testing. Can be "PRODUCTION" or "TESTING".
                "environment": self.config.environment,
            // The used sdk. It’s known by the sdk itself.
            "sdk": Trackingplan.sdk,
            // The SDK version, useful for implementing different parsing strategies. It’s known by the sdk itself.
            "sdk_version": Trackingplan.sdkVersion,
            // The rate at which this specific track has been sampled.
            "sampling_rate": sampleRate,
            // Debug mode. Makes every request return and console.log the parsed track.
                "debug": self.config.debug
        ]
        
    }
    
    private func getConfigUrl() -> String{
        return self.config.trackingplanConfigEndpoint + "config-" + self.config.tpId + ".json";
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
