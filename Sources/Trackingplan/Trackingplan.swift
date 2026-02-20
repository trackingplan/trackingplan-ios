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
     - dryRun: when enabled, the SDK will not send any data to Trackingplan. Requires debug mode. Default: false.
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
        dryRun: Bool = false,
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
            dryRun: dryRun,
            regressionTesting: regressionTesting,
            trackingplanEndpoint: trackingplanEndpoint,
            trackingplanConfigEndpoint: trackingplanConfigEndpoint
        )
    }

    /**
     Updates the tags in the current configuration by merging new tags with existing ones.
     This method can be called from any thread and will be executed safely in the Trackingplan thread.

     - Parameters:
        - newTags: The tags to add or update. New tags will be merged with existing tags, with new values overwriting existing ones for the same keys.
     */
    open class func updateTags(_ newTags: Dictionary<String, String>) {
        TrackingplanManager.sharedInstance.updateTags(newTags)
    }
}

open class TrackingplanManager  {

    internal static let logger = TrackingPlanLogger(tagName: "Trackingplan")

    public static let sdk = "ios"

    public static let defaultBatchSize = 10

    // please update to match the release version
    public static let sdkVersion = "2.0.0"

    public static let sharedInstance = TrackingplanManager()

    internal var mainInstance: TrackingplanInstance?

    @available(iOS, deprecated, message: "This method will be removed in a future release. Please, use regressionTesting: true in Trackingplan.initialize")
    public func dispatchRealTime(jsonData: NSDictionary, provider: String) {
        TrackingplanManager.logger.debug("Use of deprecated dispatchRealTimeRequest ignored. Please, use regressionTesting: true in Trackingplan.initialize")
    }

    func initialize(
        tp_id: String,
        environment: String,
        tags: Dictionary <String, String>,
        sourceAlias: String,
        customDomains: Dictionary <String, String>,
        debug: Bool,
        dryRun: Bool,
        regressionTesting: Bool,
        trackingplanEndpoint: String,
        trackingplanConfigEndpoint: String) -> TrackingplanInstance?
    {
        if mainInstance != nil {
            TrackingplanManager.logger.debug("Trackingplan already initialized. Action ignored")
            return mainInstance
        }

        if debug {
            TrackingplanManager.logger.enableLogging()
        }

        // Check if regression testing is enabled using the new regressionTesting option. Fallback to
        // environment variables for backwards compatibility.
        var regressionTestingEnabled = regressionTesting
        if !regressionTesting && TrackingplanConfig.resolveRegressionTesting() {
            TrackingplanManager.logger.debug("Enabling regression testing because test_session_name was set through environment variables")
            regressionTestingEnabled = true
        }

        // Compute final values for regression testing (immutable config)
        let finalBatchSize = regressionTestingEnabled ? 1 : TrackingplanManager.defaultBatchSize
        let finalIgnoreSampling = regressionTestingEnabled
        let finalEnvironment = regressionTestingEnabled
            ? (TrackingplanConfig.resolveEnvironment() ?? environment)
            : environment
        let finalTags = regressionTestingEnabled
            ? TrackingplanConfig.resolveTags(tags)
            : tags

        guard let config = TrackingplanConfig(
            tp_id: tp_id,
            environment: finalEnvironment,
            tags: finalTags,
            sourceAlias: sourceAlias,
            debug: debug,
            testing: regressionTestingEnabled,
            dryRun: dryRun,
            trackingplanEndpoint: trackingplanEndpoint,
            trackingplanConfigEndpoint: trackingplanConfigEndpoint,
            ignoreSampling: finalIgnoreSampling,
            providerDomains: defaultProviderDomains.merging(customDomains){ (_, new) in new },
            batchSize: finalBatchSize
        ) else {
            TrackingplanManager.logger.debug("Trackingplan initialization failed. Invalid configuration (tp_id cannot be empty or dryRun requires debug mode)")
            return nil
        }

        if dryRun {
            TrackingplanManager.logger.debug("DryRun mode enabled")
        }

        if regressionTestingEnabled {

            if config.environment == "PRODUCTION" {
                TrackingplanManager.logger.debug("Trackingplan initialization failed. Regression testing is not compatible with PRODUCTION environment.")
                return nil
            }

            if !config.tags.keys.contains("test_session_name") {
            TrackingplanManager.logger.debug("Trackingplan initialization failed. Regression testing missing test_session_name.")
                return nil
            }

            if !config.tags.keys.contains("test_title") {
            TrackingplanManager.logger.debug("Trackingplan initialization failed. Regression testing missing test_title.")
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

            TrackingplanManager.logger.debug("Trackingplan regression testing mode is enabled")
            TrackingplanManager.logger.debug("Using additional configuration: \(extraConfig)")
        }

        // Start
        if let instance = TrackingplanInstance(config: config) {
            mainInstance = instance
            mainInstance?.start()
            TrackingplanManager.logger.debug("Trackingplan v\(TrackingplanManager.sdkVersion) started")
        } else {
            TrackingplanManager.logger.debug("Trackingplan start failed")
        }

        return mainInstance
    }

    func updateTags(_ newTags: Dictionary<String, String>) {
        guard let instance = mainInstance else {
            TrackingplanManager.logger.debug("Cannot update tags. Trackingplan was not initialized")
            return
        }
        instance.updateTags(newTags)
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
    "api.segment.io": "segment",
    "segmentapi": "segment",
    "seg-api": "segment",
    "segment-api": "segment",
    "regex:api[0-9]*\\.amplitude.com": "amplitude",
    "regex:api[0-9]*\\.branch\\.io/v[0-9]+": "branch",
    "braze.com/api": "braze",
    "braze.eu/api": "braze",
    "ping.chartbeat.net": "chartbeat",
    "api.mixpanel.com/track": "mixpanel",
    "api-eu.mixpanel.com/track": "mixpanel",
    "trk.kissmetrics.io": "kissmetrics",
    "ct.pinterest.com": "pinterest",
    "facebook.com/tr/": "facebook",
    "graph.facebook.com/*/*/activities": "facebookgraph",
    "regex:ep[0-9]+\\.facebook\\.com/.*/activities": "facebookgraph",
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
    "analytics.us.tiktok.com/api/v1/app_sdk/batch": "tiktok",
    "analytics.us.tiktok.com/api/v1/app_sdk/monitor": "tiktok",
    // Firebase
    "app-measurement.com": "googleanalyticsfirebase",
    "app-analytics-services.com": "googleanalyticsfirebase",
    "app-analytics-services-att.com": "googleanalyticsfirebase"
]
