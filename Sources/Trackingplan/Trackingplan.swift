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
    /**
    Initializes and configures Trackingplan SDK. You only need to call this method once from application delegate’s method.

    - Parameters:
       - tpId: an id provided by Trackingplan which identifies your company trackingplan.
       - customDomains: allows to extend the list of monitored domains. Any request made to these domains will also be forwarded to Trackingplan. The format is {"myAnalyticsDomain.com": "myAnalytics"}, where you put, respectively, the domain to be looked for and the alias you want to use for that analytics domain. Default: {}. Example: {"mixpanel.com": "Mixpanel"}.
       - environment: allows to isolate the data between production and testing environments. Default: PRODUCTION. Example: DEV.
       - sourceAlias: allows to differentiate between sources. Default: iOS. Example: iOS App.
       - debug: shows Trackingplan debugging information in the console. Default: false. Example: true.
       - batchSize: for internal use only, please let us know if you need to change this value.
       - trackingplanEndpoint: for internal use only, please let us know if you need to change this value.
       - trackingplanConfigEndpoint: for internal use only, please let us know if you need to change this value.
       - ignoreSampling: for internal use only, please let us know if you need to change this value.
    */
    @discardableResult
    open class func initialize(
                tpId: String = "",
                environment: String? = "PRODUCTION",
                sourceAlias: String? = "",
                customDomains: Dictionary <String, String>? = [:],
                debug: Bool? = false,
                trackingplanEndpoint: String? = "https://tracks.trackingplan.com/v2",
                trackingplanConfigEndpoint: String? = "https://config.trackingplan.com/",
                ignoreSampling: Bool? = false,
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
    public static let sdkVersion = "1.0.24" 
    
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
        trackingplanEndpoint: String? = "https://tracks.trackingplan.com/v2",
        trackingplanConfigEndpoint: String? = "https://config.trackingplan.com/",
        ignoreSampling: Bool? = false,
        customDomains: Dictionary <String, String>? = [:],
        batchSize: Int = 10,
        instanceName: String? = "default") -> TrackingplanInstance {
        
        var providerDomains = defaultProviderDomains
        if(customDomains != nil){
            providerDomains = defaultProviderDomains.merging(customDomains!){ (_, new) in new }
        }
        
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
        "google-analytics.com": "googleanalytics",
        "analytics.google.com": "googleanalytics",
        "api.segment.io": "segment",
        "segmentapi": "segment",
        "seg-api": "segment",
        "segment-api": "segment",
        // "/.*api\-iam\.intercom\.io\/messenger\/web\/(ping|events|metrics|open).*/": "intercom",
        "api.amplitude.com": "amplitude",
        "api2.amplitude.com": "amplitude",
        "ping.chartbeat.net": "chartbeat",
        // "/.*api(-eu)?(-js)?.mixpanel\.com.*/": "mixpanel",
        "trk.kissmetrics.io": "kissmetrics",
        "ct.pinterest.com": "pinterest",
        "facebook.com/tr/": "facebook",
        "track.hubspot.com/__": "hubspot",
        // "/.*\.heapanalytics\.com\/(h|api).*/": "heap",
        // "/.*snowplow.*/": "snowplow",
        // "/.*ws.*\.hotjar\.com\/api\/v2\/client\/ws/%identify_user": "hotjar",
        // "/.*ws.*\.hotjar\.com\/api\/v2\/client\/ws/%tag_recording": "hotjar",
        "klaviyo.com/api/track": "klaviyo",
        "app.pendo.io/data": "pendo",
        "matomo.php": "matomo",
        "rs.fullstory.com/rec%8137": "fullstory",
        "rs.fullstory.com/rec%8193": "fullstory",
        "logx.optimizely.com/v1/events": "optimizely",
        "track.customer.io/events/": "customerio",
        "alb.reddit.com/rp.gif": "reddit",
        "px.ads.linkedin.com": "linkedin",
        "/i/adsct": "twitter",
        "bat.bing.com": "bing",
        "pdst.fm": "podsights",
        "app-measurement.com": "googleanalyticsfirebase"
    ]
