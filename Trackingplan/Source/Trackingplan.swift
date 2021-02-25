//
//  TrackingPlan.swift
//  Trackingplan
//
//
//  Created by José Luis Pérez on 24/2/21.
//
//  Trackingplan(tpId: "zara-ios-test", debug: true).start()
//

import Foundation
import NetworkInterceptor



@objc public class Trackingplan: NSObject {
    
    private static let interceptor = NetworkInterceptor()
    private var requestHandler: TrackingPlanRequestHandler
    public static let sdk = "ios"
    public static let sdkVersion = "0.0.1" // we could get this from the pod.
    
    public init(tpId: String = "",
                environment: String? = "PRODUCTION",
                sourceAlias: String? = "",
                debug: Bool? = false,
                trackingplanEndpoint: String? = "https://tracks.trackingplan.com/",
                trackingplanConfigEndpoint: String? = "https://config.trackingplan.com/",
                ignoreSampling: Bool? = false,
                customDomains: Dictionary <String, String>? = [:]) {
        
        let providerDomains = defaultProviderDomains.merging(customDomains!){ (_, new) in new }

        let config = TrackingplanConfig(tpId: tpId, environment: environment, sourceAlias: sourceAlias, debug: debug, trackingplanEndpoint: trackingplanEndpoint, trackingplanConfigEndpoint: trackingplanConfigEndpoint, ignoreSampling: ignoreSampling, providerDomains: providerDomains)
        
        self.requestHandler = TrackingPlanRequestHandler(config: config)
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
