//
//  TrackingPlan.swift
//  Trackingplan
//
//
//  Created by José Luis Pérez on 24/2/21.
//
//  Trackingplan.init(tpId: "zara-ios-test", options: ["debug": true, "customDomains": ["zenit", "zara-zenit]]).start()
//


/* TODO
 - Make sure installing that after installing tp, everything is not blocking the main thread (or anything!)
 - Try Catch everything. App should not ever be broken by this package.
 - Probably convert config dictionary into a struct / class
 - Shared member (singleton I guess), so trackingplan object can be accessed through Trackingplan.shared() anywhere in the app. i.e. for stopping it. PTAL at how NetworkInterceptor itself does it, or mimic how other analytics do it.
 - Add swift packages support
 - Add Carthage support.
 - Find out the swift version that is safe for pods and use that version functions
 - Ensure this is compatible with ObjC apps.
 - Use the config endpoint response, do not mock
 - Logging, debug mode, not print.

 */


import Foundation
import NetworkInterceptor




@objc public class Trackingplan: NSObject {

    private static let interceptor = NetworkInterceptor()
    private var requestHandler: TrackingPlanRequestHandler
    public static let sdk = "ios"
    public static let sdkVersion = "0.0.1" // we could get this from the pod.
    
    public init(tpId: String, options: Dictionary<String, Any> = [:]) {
        var parameters = defaultOptions
        parameters.mergeDict(dict: options)
        var domains = defaultProviderDomains
        domains.mergeDict(dict: parameters["customDomains"] as! [String : String])
        parameters["providerDomains"] = domains
        parameters["tpId"] = tpId
        
        self.requestHandler = TrackingPlanRequestHandler(options: parameters)
    }
    @objc public func start(){
        let requestSniffers: [RequestSniffer] = [
            RequestSniffer(requestEvaluator: AnyHttpRequestEvaluator(), handlers: [
                self.requestHandler
            ])
        ]

        let networkConfig = NetworkInterceptorConfig(requestSniffers: requestSniffers)
        NetworkInterceptor.shared.setup(config: networkConfig)
        NetworkInterceptor.shared.startRecording()
    }
    
    @objc public func stop(){
        NetworkInterceptor.shared.stopRecording()
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
        "ignoreSampling": true // For testing purposes.
    ]

private var defaultProviderDomains: Dictionary<String, String> =
    [
        "google-analytics.com": "googleanalytics",
        "api.segment.com": "segment",
        "api.segment.io": "segment",
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
