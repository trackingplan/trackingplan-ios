//
//  TrackingplanConfig.swift
//  Trackingplan
//

import Foundation

public struct TrackingplanConfig {
    var tp_id: String
    var environment: String
    var tags: Dictionary<String, String>
    var sourceAlias: String
    var debug: Bool
    var trackingplanEndpoint: String
    var trackingplanConfigEndpoint: String
    var ignoreSampling: Bool
    var providerDomains: Dictionary<String, String>
    var batchSize: Int
}

public enum TrackingplanTag: String, CaseIterable {

    case tagName = "TP_TAG_"
    case environment = "TP_ENVIRONMENT"
    case testSessionName = "TP_TAG_test_session_name"


    /// Create an argument Tracking Plan tag that will be used as pair KEY and VALUE.
    /// This should come from a [String : String] dictionary such ProcessInfo().environment
    /// - Parameters:
    ///     - value: original string from the source
    ///
    /// - Returns: preform string tag to be recognized by Tracking Plan.
    public func keyWithName(_ value: String) -> String {
        return TrackingplanTag.tagName.rawValue + value
    }
}

//Basic convenience init and sample rate
extension TrackingplanConfig {

    @discardableResult
    static func resolveTags(_ tags: [String : String]) -> [String : String] {
        var tpTags = tags
        //Environment tags
        ProcessInfo().environment.forEach { k, value in
            if k.starts(with: TrackingplanTag.tagName.rawValue) {
                tpTags[k.replacingOccurrences(of: TrackingplanTag.tagName.rawValue, with: "")] = value
            }
        }

        return tpTags
    }

    static func resolveEnvironment() -> String? {
        var environment: String?
        ProcessInfo().environment.forEach { k, value in
            if k == TrackingplanTag.environment.rawValue {
                environment = value
            }
        }
        return environment
    }
    

    static func resolveRegressionTesting() -> Bool {
        if let sessionName = ProcessInfo().environment[TrackingplanTag.testSessionName.rawValue], !sessionName.isEmpty {
            return true
        }
        return false
    }


    static func getCurrentTimestamp() -> TimeInterval {
        Date().timeIntervalSince1970
    }

    func sampleRateURL() -> URL? {
       return URL(string:trackingplanConfigEndpoint + "config-" + tp_id + ".json")
    }
}
