//
//  TrackingPlan.swift
//  Trackingplan
//
//
//  Created by José Luis Pérez on 24/2/21.
//
//  Trackingplan(tp_id: "zara-ios-test", debug: true).start()
//

import Foundation
import UIKit


open class TrackingPlan {
    @discardableResult
    open class func initialize(
                tpId: String = "",
                environment: String? = "PRODUCTION",
                sourceAlias: String? = "",
                debug: Bool? = false,
                trackingplanEndpoint: String? = "https://tracks.trackingplan.com/",
                trackingplanConfigEndpoint: String? = "https://config.trackingplan.com/",
                ignoreSampling: Bool? = false,
                customDomains: Dictionary <String, String>? = [:], 
                batchSize: Int = 10) -> TrackingPlanInstance {

        print("Hi from TP 0.0.20")
        
        return TrackingplanManager.sharedInstance.initialize(
            tp_id: tpId, 
            environment: environment, 
            sourceAlias: sourceAlias, 
            debug: debug, 
            trackingplanEndpoint: trackingplanEndpoint, 
            trackingplanConfigEndpoint: trackingplanConfigEndpoint, 
            ignoreSampling: ignoreSampling, 
            customDomains: customDomains, 
            batchSize: batchSize)
    }
}


class TrackingplanManager  {
    public static let sdk = "ios"
    public static let sdkVersion = "0.0.1" // we could get this from the pod.
    
    static let sharedInstance = TrackingplanManager()
    private var mainInstance: TrackingPlanInstance?
    private var instances: [String: TrackingPlanInstance]
    private let readWriteLock: ReadWriteLock
    
    init() {
        instances = [String: TrackingPlanInstance]()
        readWriteLock = ReadWriteLock(label: "com.trackingplanios.instance.manager.lock")
    }
    
    func initialize(
        tp_id: String = "",
        environment: String? = "PRODUCTION",
        sourceAlias: String? = "",
        debug: Bool? = false,
        trackingplanEndpoint: String? = "https://tracks.trackingplan.com/",
        trackingplanConfigEndpoint: String? = "https://config.trackingplan.com/",
        ignoreSampling: Bool? = false,
        customDomains: Dictionary <String, String>? = [:], 
        batchSize: Int = 10,
        instanceName: String? = "default") -> TrackingPlanInstance {
        
        let providerDomains = defaultProviderDomains.merging(customDomains!){ (_, new) in new }
        let config = TrackingplanConfig(
            tp_id: tp_id,
            environment: environment,
            sourceAlias: sourceAlias,
            debug: debug,
            trackingplanEndpoint: trackingplanEndpoint,
            trackingplanConfigEndpoint: trackingplanConfigEndpoint,
            ignoreSampling: ignoreSampling,
            providerDomains: providerDomains,
            batchSize: batchSize)
        
        let instance = TrackingPlanInstance(config: config)
        mainInstance = instance
        readWriteLock.write {
            instances[instanceName ?? "default"] = instance
        }
        return instance
    }
}

open class TrackingPlanInstance {
    private static let interceptor = NetworkInterceptor()
    private var requestHandler: TrackingPlanRequestHandler
    private var config: TrackingplanConfig

    let readWriteLock: ReadWriteLock
    var trackingQueue: DispatchQueue!
    var networkQueue: DispatchQueue!

    init(config: TrackingplanConfig) {
        let label = "com.trackingPlan.\(config.tp_id)"
        trackingQueue = DispatchQueue(label: "\(label).tracking)", qos: .utility)
        networkQueue = DispatchQueue(label: "\(label).network)", qos: .utility)
        self.requestHandler = TrackingPlanRequestHandler(config: config, queue: trackingQueue)
        self.readWriteLock = ReadWriteLock(label: "com.trackingPlan.globallock")
        self.config = config
        setupObservers()
        start()
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(applicationWillTerminate(_:)),
                                       name: UIApplication.willTerminateNotification,
                                       object: nil)
       
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(applicationDidEnterForeground(_:)),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
    }
    
    fileprivate func start(){
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @discardableResult
    static func sharedUIApplication() -> UIApplication? {
        guard let sharedApplication = UIApplication.perform(NSSelectorFromString("sharedApplication"))?.takeUnretainedValue() as? UIApplication 
        else {
            return nil
        }
        return sharedApplication
    }
    
    @objc private func applicationDidEnterForeground(_ notification: Notification) {
        networkQueue.async {
            self.requestHandler.networkManager.retrieveForEmptySampleRate()
        }
    }
    
    @objc private func applicationWillTerminate(_ notification: Notification) {
        NotificationCenter.default.post(name: TrackingPlanQueue.archiveNotificationName, object: nil)
    }
   

}

private var defaultProviderDomains: Dictionary<String, String> =
    [
        "app-measurement.com": "googleanalyticsfirebase",
        "firebaselogging-pa.googleapis.com": "googleanalyticsfirebase",
        "www.google-analytics.com": "googleanalytics",
        "ssl.google-analytics.com": "googleanalytics",
        "google-analytics.com": "googleanalytics",
        "analytics.google.com": "googleanalytics",
        "api.segment.io": "segment",
        "api.segment.com": "segment",
        "quantserve.com": "quantserve",
        "api.intercom.io": "intercom",
        "api.amplitude.com": "amplitude",
        "ping.chartbeat.net": "chartbeat",
        "api.mixpanel.com": "mixpanel",
        "kissmetrics.com": "kissmetrics",
        "sb.scorecardresearch.com": "scorecardresearch"
    ]
