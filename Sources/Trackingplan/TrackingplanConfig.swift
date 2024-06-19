//
//  TrackingplanConfig.swift
//  Trackingplan
//

import Foundation

public struct TrackingplanConfig {
    var tp_id: String
    var environment: String
    var tags: Dictionary <String, String>
    var sourceAlias: String
    var debug: Bool
    var trackingplanEndpoint: String
    var trackingplanConfigEndpoint: String
    var ignoreSampling: Bool
    var providerDomains: Dictionary <String, String>
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

// Rolling to send same value every 24h set
extension TrackingplanConfig {
    public func shouldTrackRequest(rate: Int) -> Bool {
        
        if self.ignoreSampling {
            return true
        }
        
        // Grab last date value
        if let lastDate = UserDefaultsHelper.getData(type: TimeInterval.self, forKey: .rolledDiceDate) {
            if TrackingplanConfig.getCurrentTimestamp() > lastDate + 86400 {
                //Logger.debug(message: TrackingplanMessage.message("\(String(describing: TrackingplanConfig.self)) Reset roll dice - last timestamp: \(lastDate)"))
                return setRandomValue(rate: rate)
            } else {
                let currentValue = UserDefaultsHelper.getData(type: Bool.self, forKey: .rolleDiceValue) ?? true
                //Logger.debug(message: TrackingplanMessage.message("Using existing rolling value: \(currentValue) "))
                return currentValue
            }
        } else {
            return setRandomValue(rate: rate)
        }
    }

    @discardableResult
    fileprivate func setRandomValue (rate: Int) -> Bool {
        let randomNumber = Float(arc4random()) / Float(UInt32.max)

        let newTs = TrackingplanConfig.getCurrentTimestamp()
        UserDefaultsHelper.setData(value: newTs, key: .rolledDiceDate)
        //Logger.debug(message: TrackingplanMessage.message("Rolled new timestamp: \(newTs) "))

        let rolled = randomNumber < (1 / Float(rate))
        UserDefaultsHelper.setData(value: rolled, key: .rolleDiceValue)
        //Logger.debug(message: TrackingplanMessage.message("Rolled new value: \(rolled) "))

        return rolled
    }
}
