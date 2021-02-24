
import Foundation
import NetworkInterceptor

// Be careful, use Swift 2 functions if possible. https://www.cerebralgardens.com/blog/entry/2017/10/04/mix-and-match-swift-3-swift-4-libraries-with-cocoapods#:~:text=As%20you%20know%2C%20when%20using,project%2C%20and%20a%20Pods%20project.&text=This%20means%20Xcode%20will%20try,of%20Swift%20is%20actually%20needed.


@objc public class Trackingplan: NSObject {
    
    private static let interceptor = NetworkInterceptor()
    private var requestHandler: TrackingPlanRequestHandler
    
    public init(tpId: String, options: Dictionary<String, Any> = [:]) {
        var parameters = defaultOptions
        parameters.mergeDict(dict: options)
        var domains = defaultProviderDomains
        domains.mergeDict(dict: parameters["customDomains"] as! [String : String])
        parameters["providerDomains"] = domains
        parameters["tpId"] = tpId
        //downloadSampleRate()
        
        self.requestHandler = TrackingPlanRequestHandler(options: parameters)
    }
    public func start(){
        
        let requestSniffers: [RequestSniffer] = [
            RequestSniffer(requestEvaluator: AnyHttpRequestEvaluator(), handlers: [
                self.requestHandler
            ])
        ]

        let networkConfig = NetworkInterceptorConfig(requestSniffers: requestSniffers)
        NetworkInterceptor.shared.setup(config: networkConfig)
        NetworkInterceptor.shared.startRecording()
    }
    
    public func stop(){
        NetworkInterceptor.shared.stopRecording()
    }
    
    

    

    
}


public class TrackingPlanRequestHandler: SniffableRequestHandler {
    private var options: Dictionary<String, Any?>
    private var queue: [URLRequest] = []
    private var updatingSampleRate = false
    
    public init(options: Dictionary<String, Any?>){
        self.options = options
        self.updateSampleRateAndProcessQueue()
    }
    
    /* This function name cannot be changed*/
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
        if(sampleRate == 0.0){
            print("APPEND TO QUEUE "+String(self.queue.count))
            self.queue.append(urlRequest)
            return false
        }
        
        if((Float(arc4random()) / Float(UInt32.max)) > 1 / sampleRate ){ // rolling the sampling dice
            
            return true;
        }
        
        self.sendToTrackingPlan(urlRequest: urlRequest, provider: provider!)
        
        return true
    }
    
    private func sendToTrackingPlan(urlRequest: URLRequest, provider: String){
        print("SENDING TO TP "+provider)
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
    public func setSampleRate(sampleRate: Float){
        print("SET SAMPLE RATE A "+String(sampleRate))
        UserDefaults.standard.set(sampleRate, forKey: "TrackingplanSampleRate")
        //UserDefaults.standard.removeObject(forKey: "TrackingplanSampleRate")
    }
    
    public func getSampleRate() -> Float{
        let sampleRate = UserDefaults.standard.float(forKey: "TrackingplanSampleRate")
        print("GET SAMPLE RATE "+String(sampleRate))
        return sampleRate
        
    }
    
    public func updateSampleRateAndProcessQueue(){
        if(self.updatingSampleRate) {
            return
        }
        self.updatingSampleRate = true;
        let sampleRate = self.getSampleRate()
        if(sampleRate == 0.0) {

        let url = URL(string: "http://www.stackoverflow.com")!

            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else {
                    self.updatingSampleRate = false
                    return
                }
                self.setSampleRate(sampleRate: 2.0)
                
                self.processQueue()
                self.updatingSampleRate = false;
            }
            task.resume()
        }
    }

    
}

private var defaultOptions: Dictionary<String, Any?> =
    [

        "environment": "PRODUCTION",
        "sourceAlias": nil,
        "trackingplanMethod": "xhr",
        "customDomains": [:],
        "debug": false,
        "trackingplanEndpoint": "https://tracks.trackingplan.com/", // Can be overwritten.
        "trackingplanConfigEndpoint": "https://config.trackingplan.com/", // Can be overwritten.
        "delayConfigDownload": 5, // For testing queue and sync purposes.
        "ignoreSampling": false // For testing purposes.
    ]

private var defaultProviderDomains: Dictionary<String, String> =
    [
        "google-analytics.com": "googleanalytics",
        "segment.com": "segment",
        "segment.io": "segment",
        "quantserve.com": "quantserve",
        "intercom.com": "intercom",
        "amplitude": "amplitude",
        "appsflyer": "appsflyer",
        "fullstory": "fullstory",
        "mixpanel": "mixpanel",
        "kissmetrics": "kissmetrics",
        "hull.io": "hull",
        "hotjar": "hotjar"
    ]



extension Dictionary {
    mutating func mergeDict(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
