//
//  Trackingplan.swift
//  Trackingplan
//
//
//  Created by José Luis Pérez on 24/2/21.
//
//  Trackingplan(tp_id: "zara-ios-test", debug: true).start()
//

import os
import Foundation
import UIKit

open class Trackingplan {
    /**
     Initializes and configures Trackingplan SDK. You only need to call this method once from application delegate’s method.

     - Parameters:
     - tpId: an id provided by Trackingplan which identifies your company trackingplan.
     - environment: allows to isolate the data between production and other environments. Default: PRODUCTION. Example: DEV.
     - tags: allows to add tags to the data sent to Trackingplan. Default: {}. Example: {"appVersion": "1.0.0"}. Use it to tag you execution, e.g. with a test name, release number, etc. This will be shown in Trackingplan warnings for debugging.
     - sourceAlias: allows to differentiate between sources. Default: iOS. Example: iOS App.
     - customDomains: allows to extend the list of monitored domains. Any request made to these domains will also be forwarded to Trackingplan. The format is {"myAnalyticsDomain.com": "myAnalytics"}, where you put, respectively, the domain to be looked for and the alias you want to use for that analytics domain. Default: {}. Example: {"mixpanel.com": "Mixpanel"}.
     - debug: shows Trackingplan debugging information in the console. Default: false. Example: true.
     - regressionTesting: when enabled, Trackingplan iOS SDK is configured to run correctly in testing environments. Default: false.
     - trackingplanEndpoint: for internal use only, please let us know if you need to change this value.
     - trackingplanConfigEndpoint: for internal use only, please let us know if you need to change this value.
     */
    @discardableResult
    open class func initialize(
        tpId: String = "",
        environment: String = "PRODUCTION",
        tags: Dictionary <String, String> = [:],
        sourceAlias: String = "ios",
        customDomains: Dictionary <String, String> = [:],
        debug: Bool = false,
        regressionTesting: Bool = false,
        trackingplanEndpoint: String = "https://eu-tracks.trackingplan.com/v1/",
        trackingplanConfigEndpoint: String = "https://config.trackingplan.com/"
    ) -> TrackingplanInstance? {
        return TrackingplanManager.sharedInstance.initialize(
            tp_id: tpId,
            environment: environment,
            tags: tags,
            sourceAlias: sourceAlias,
            customDomains: customDomains,
            debug: debug,
            regressionTesting: regressionTesting,
            trackingplanEndpoint: trackingplanEndpoint,
            trackingplanConfigEndpoint: trackingplanConfigEndpoint
        )
    }
}

open class TrackingplanManager  {

    internal static let logger = TrackingPlanLogger(tagName: "Trackingplan")

    public static let sdk = "ios"

    public static let defaultBatchSize = 10

    // please update to match the release version
    public static let sdkVersion = "1.3.0"

    public static let sharedInstance = TrackingplanManager()

    private var mainInstance: TrackingplanInstance?

    @available(iOS, deprecated, message: "This method will be removed in a future release. Please, use regressionTesting: true in Trackingplan.initialize")
    public func dispatchRealTime(jsonData: NSDictionary, provider: String) {
        TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Use of deprecated dispatchRealTimeRequest ignored. Please, use regressionTesting: true in Trackingplan.initialize"))
    }

    func initialize(
        tp_id: String,
        environment: String,
        tags: Dictionary <String, String>,
        sourceAlias: String,
        customDomains: Dictionary <String, String>,
        debug: Bool,
        regressionTesting: Bool,
        trackingplanEndpoint: String,
        trackingplanConfigEndpoint: String) -> TrackingplanInstance?
    {
        if mainInstance != nil {
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Trackingplan already initialized. Action ignored"))
            return mainInstance
        }

        if debug {
            TrackingplanManager.logger.enableLogging()
        }
        
        // Check if regression testing is enabled using the new regressionTesting option. Fallback to
        // environment variables for backwards compatibility.
        var regressionTestingEnabled = regressionTesting
        if !regressionTesting && TrackingplanConfig.resolveRegressionTesting() {
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Enabling regression testing because test_session_name was set through environment variables"))
            regressionTestingEnabled = true
        }

        var config = TrackingplanConfig(
            tp_id: tp_id,
            environment: environment,
            tags: tags,
            sourceAlias: sourceAlias,
            debug: debug,
            testing: regressionTestingEnabled,
            trackingplanEndpoint: trackingplanEndpoint,
            trackingplanConfigEndpoint: trackingplanConfigEndpoint,
            ignoreSampling: false,
            providerDomains: defaultProviderDomains.merging(customDomains){ (_, new) in new },
            batchSize: TrackingplanManager.defaultBatchSize
        )

        if regressionTestingEnabled {
            
            config.batchSize = 1
            config.ignoreSampling = true

            // Setup environment and tags for regression testing using TP_ENVIRONMENT and TP_TAG_X environment variables.
            // If not set, use the provided environment and tags as a fallback.
            config.environment = TrackingplanConfig.resolveEnvironment() ?? environment
            config.tags = TrackingplanConfig.resolveTags(tags)

            if config.environment == "PRODUCTION" {
                TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Trackingplan initialization failed. Regression testing is not compatible with PRODUCTION environment."))
                return nil
            }

            if !config.tags.keys.contains("test_session_name") {
                TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Trackingplan initialization failed. Regression testing missing test_session_name."))
                return nil
            }

            if !config.tags.keys.contains("test_title") {
                TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Trackingplan initialization failed. Regression testing missing test_title."))
                return nil
            }

            struct ExtraOptions {
                var environment: String
                var testSessionName: String
                var testTitle: String
                var batchSize: Int
            }
            let extraConfig = ExtraOptions(environment: config.environment,
                                           testSessionName: config.tags["test_session_name"]!,
                                           testTitle: config.tags["test_title"]!,
                                           batchSize: config.batchSize)

            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Trackingplan regression testing mode is enabled"))
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Using additional configuration: \(extraConfig)"))
        }

        // Start
        if let instance = TrackingplanInstance(config: config) {
            mainInstance = instance
            mainInstance?.start()
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Trackingplan v\(TrackingplanManager.sdkVersion) started"))
        } else {
            TrackingplanManager.logger.debug(message: TrackingplanMessage.message("Trackingplan start failed"))
        }
        
        return mainInstance
    }
}

extension Bundle {
    public var appName: String           { getInfo("CFBundleName")  }
    public var displayName: String       { getInfo("CFBundleDisplayName")}
    public var language: String          { getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String        { getInfo("CFBundleIdentifier")}
    public var copyright: String         { getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }

    public var appBuild: String          { getInfo("CFBundleVersion") }
    public var appVersionLong: String    { getInfo("CFBundleShortVersionString") }

    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

private var defaultProviderDomains: Dictionary<String, String> =
[
    "google-analytics.com": "googleanalytics",
    "analytics.google.com": "googleanalytics",
    "api.segment.io": "segment",
    "segmentapi": "segment",
    "seg-api": "segment",
    "segment-api": "segment",
    "api.amplitude.com": "amplitude",
    "api2.amplitude.com": "amplitude",
    "braze.com/api": "braze",
    "braze.eu/api": "braze",
    "ping.chartbeat.net": "chartbeat",
    "api.mixpanel.com/track": "mixpanel",
    "api-eu.mixpanel.com/track": "mixpanel",
    "trk.kissmetrics.io": "kissmetrics",
    "ct.pinterest.com": "pinterest",
    "facebook.com/tr/": "facebook",
    "track.hubspot.com/__": "hubspot",
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
    // Firebase
    "app-measurement.com": "googleanalyticsfirebase",
    "app-analytics-services.com": "googleanalyticsfirebase",
    "app-analytics-services-att.com": "googleanalyticsfirebase"
]
