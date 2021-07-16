//
//  Trackingplan.swift
//  Trackingplan
//
//
//  Created by José Luis Pérez on 24/2/21.
//
//  Trackingplan(tp_id: "zara-ios-test", debug: true).start()
//

import Foundation
import UIKit


open class Trackingplan {
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
                batchSize: Int = 10) -> TrackingplanInstance {
        
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

    // please update to match the release version
    public static let sdkVersion = "1.0.12" 
    
    static let sharedInstance = TrackingplanManager()
    private var mainInstance: TrackingplanInstance?
    private var instances: [String: TrackingplanInstance]
    private let readWriteLock: ReadWriteLock
    
    init() {
        instances = [String: TrackingplanInstance]()
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
        instanceName: String? = "default") -> TrackingplanInstance {
        
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
        
        let instance = TrackingplanInstance(config: config)
        mainInstance = instance
        readWriteLock.write {
            instances[instanceName ?? "default"] = instance
        }
        return instance
    }
}

open class TrackingplanInstance {
    private static let interceptor = NetworkInterceptor()
    private var requestHandler: TrackingplanRequestHandler
    private var config: TrackingplanConfig

    let readWriteLock: ReadWriteLock
    var trackingQueue: DispatchQueue!
    var networkQueue: DispatchQueue!

    init(config: TrackingplanConfig) {
        let label = "com.trackingplan.\(config.tp_id)"
        trackingQueue = DispatchQueue(label: "\(label).tracking)", qos: .utility)
        networkQueue = DispatchQueue(label: "\(label).network)", qos: .utility)
        self.requestHandler = TrackingplanRequestHandler(config: config, queue: trackingQueue)
        self.readWriteLock = ReadWriteLock(label: "com.trackingplan.globallock")
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
                                       selector: #selector(applicationWillEnterForeground(_:)),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
    
        
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(applicationDidEnterBackground(_:)),
                                       name: UIApplication.didEnterBackgroundNotification,
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
    
    @objc private func applicationWillEnterForeground(_ notification: Notification) {
        NotificationCenter.default.post(name: TrackingplanNetworkManager.SendNotificationName, object: false)
            self.requestHandler.networkManager.retrieveForEmptySampleRate()
    }
    
    @objc private func applicationWillTerminate(_ notification: Notification) {
        NotificationCenter.default.post(name: TrackingplanQueue.ArchiveNotificationName, object: nil)
    }
    
    @objc private func applicationDidEnterBackground(_ notification: Notification) {
        // Max permited execution time is 5 seconds, so please use no more then 2s for waiting
        sleep(2)
        self.requestHandler.networkManager.resolveStackAndSend()
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
