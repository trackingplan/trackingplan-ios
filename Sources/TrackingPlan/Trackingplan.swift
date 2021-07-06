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
import UIKit


open class TrackingPlan {
    @discardableResult
    open class func initialize(tpId: String = "",
                environment: String? = "PRODUCTION",
                sourceAlias: String? = "",
                debug: Bool? = false,
                trackingplanEndpoint: String? = "https://tracks.trackingplan.com/",
                trackingplanConfigEndpoint: String? = "https://config.trackingplan.com/",
                ignoreSampling: Bool? = false,
                customDomains: Dictionary <String, String>? = [:], batchSize: Int = 10) -> TrackingPlanInstance {
        
        return TrackingplanManager.sharedInstance.initialize(tpId: tpId, environment: environment, sourceAlias: sourceAlias, debug: debug, trackingplanEndpoint: trackingplanEndpoint, trackingplanConfigEndpoint: trackingplanConfigEndpoint, ignoreSampling: ignoreSampling, customDomains: customDomains)
    }
}


open class TrackingplanManager: NSObject {
    public static let sdk = "ios"
    public static let sdkVersion = "0.0.1" // we could get this from the pod.
    
    static let sharedInstance = TrackingplanManager()
    private var mainInstance: TrackingplanManager?
    
    func initialize(tpId: String = "",
                         environment: String? = "PRODUCTION",
                         sourceAlias: String? = "",
                         debug: Bool? = false,
                         trackingplanEndpoint: String? = "https://tracks.trackingplan.com/",
                         trackingplanConfigEndpoint: String? = "https://config.trackingplan.com/",
                         ignoreSampling: Bool? = false,
                         customDomains: Dictionary <String, String>? = [:], batchSize: Int = 10) -> TrackingPlanInstance {
       
        let providerDomains = defaultProviderDomains.merging(customDomains!){ (_, new) in new }
        let config = TrackingplanConfig(tpId: tpId, environment: environment, sourceAlias: sourceAlias, debug: debug, trackingplanEndpoint: trackingplanEndpoint, trackingplanConfigEndpoint: trackingplanConfigEndpoint, ignoreSampling: ignoreSampling, providerDomains: providerDomains, batchSize: batchSize)

        let instance = TrackingPlanInstance(config: config)
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
        let label = "com.trackingPlan.\(config.tpId)"
        trackingQueue = DispatchQueue(label: "\(label).tracking)", qos: .utility)
        networkQueue = DispatchQueue(label: "\(label).network)", qos: .utility)
        self.requestHandler = TrackingPlanRequestHandler(config: config, queue: trackingQueue)
        self.readWriteLock = ReadWriteLock(label: "com.trackingPlan.globallock")
        self.config = config
        self.setupObservers()
    }
    
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(applicationWillTerminate(_:)),
                                       name: UIApplication.willTerminateNotification,
                                       object: nil)
       
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(applicationDidBecomeActive(_:)),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(applicationDidEnterBackground(_:)),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @discardableResult
    static func sharedUIApplication() -> UIApplication? {
        guard let sharedApplication = UIApplication.perform(NSSelectorFromString("sharedApplication"))?.takeUnretainedValue() as? UIApplication else {
            return nil
        }
        return sharedApplication
    }
    
    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        networkQueue.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.requestHandler.networkManager.unarchive()
        }
    }
    
    @objc private func applicationDidEnterBackground(_ notification: Notification) {
        //Hold for frameworks that take care of it already
        networkQueue.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.requestHandler.networkManager.unarchive()

        }
    }
    
    @objc private func applicationWillTerminate(_ notification: Notification) {
        //Hold for frameworks that take care of it already
        networkQueue.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.requestHandler.networkManager.archive()
        }
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
