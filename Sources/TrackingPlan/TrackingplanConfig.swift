//
//  TrackingplanConfig.swift
//  Trackingplan
//
//  Created by Juan Pedro Lozano 12/07/21
//

import Foundation

public struct TrackingplanConfig {
    var tp_id: String
    var environment: String
    var sourceAlias: String
    var debug: Bool
    var trackingplanEndpoint: String
    var trackingplanConfigEndpoint: String
    var ignoreSampling: Bool
    var providerDomains: Dictionary <String, String>
    var batchSize: Int
    
  
}

//Basic convenience init and sample rate

extension TrackingplanConfig {
    init(tp_id: String? = "",
                environment: String? = "PRODUCTION",
                sourceAlias: String? = "",
                debug: Bool? = false,
                trackingplanEndpoint: String? = "https://tracks.trackingplan.com/",
                trackingplanConfigEndpoint: String? = "https://config.trackingplan.com/",
                ignoreSampling: Bool? = false,
                providerDomains: Dictionary <String, String>? = [:], batchSize: Int = 10
    ){
        self.tp_id = tp_id!
        self.environment = environment!
        self.sourceAlias = sourceAlias!
        self.debug = debug!
        self.trackingplanEndpoint = trackingplanEndpoint!
        self.trackingplanConfigEndpoint = trackingplanConfigEndpoint!
        self.ignoreSampling = ignoreSampling!
        self.providerDomains = providerDomains!
        self.batchSize = batchSize
    }
    
    static func getCurrentTimestamp() -> TimeInterval {
        Date().timeIntervalSince1970
    }
    
    func sampleRateURL() -> URL? {
       return URL(string:trackingplanConfigEndpoint + "config-" + tp_id + ".json")
    }
}

//Rolling to send same value every 24h set

extension TrackingplanConfig {
    public func shouldUpdate(rate: Int) -> Bool {
        //Grab last date value
        if let lastDate = UserDefaultsHelper.getData(type: TimeInterval.self, forKey: .rolledDicedate) {
            if TrackingplanConfig.getCurrentTimestamp() > lastDate + 86400 {
                //Logger.debug(message: TrackingPlanMessage.message("\(String(describing: TrackingplanConfig.self)) Reset roll dice - last timestamp: \(lastDate)"))
                return setRandomValue(rate: rate)
            } else {
                let currentValue = UserDefaultsHelper.getData(type: Bool.self, forKey: .rolledDicedate) ?? true
                //Logger.debug(message: TrackingPlanMessage.message("Using existing rolling value: \(currentValue) "))
                return currentValue

            }
        } else {
            return setRandomValue(rate: rate)
        }
    }
    
    @discardableResult
    fileprivate func setRandomValue (rate: Int) -> Bool {
        let sampleInitialValue = self.ignoreSampling ? 0.0 : (Float(arc4random()) / Float(UInt32.max))
      
        let newTs = TrackingplanConfig.getCurrentTimestamp()
        UserDefaultsHelper.setData(value: newTs, key: .rolledDicedate)
        //Logger.debug(message: TrackingPlanMessage.message("Rolled new timestamp: \(newTs) "))

        let rolled = sampleInitialValue < (1 / Float(rate))
        UserDefaultsHelper.setData(value: rolled, key: .rolleDiceValue)
        //Logger.debug(message: TrackingPlanMessage.message("Rolled new value: \(rolled) "))

        return rolled
    }
}
