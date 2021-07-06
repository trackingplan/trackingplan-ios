//
//  TrackingplanConfig.swift
//  Trackingplan
//
//  Created by José Luis Pérez on 25/2/21.
//

import Foundation

public struct TrackingplanConfig {
    var tpId: String
    var environment: String
    var sourceAlias: String
    var debug: Bool
    var trackingplanEndpoint: String
    var trackingplanConfigEndpoint: String
    var ignoreSampling: Bool
    var providerDomains: Dictionary <String, String>
    var batchSize: Int
}
extension TrackingplanConfig {
    init(tpId: String? = "",
                environment: String? = "PRODUCTION",
                sourceAlias: String? = "",
                debug: Bool? = false,
                trackingplanEndpoint: String? = "https://tracks.trackingplan.com/",
                trackingplanConfigEndpoint: String? = "https://config.trackingplan.com/",
                ignoreSampling: Bool? = false,
                providerDomains: Dictionary <String, String>? = [:], batchSize: Int = 10
    ){
        self.tpId = tpId!
        self.environment = environment!
        self.sourceAlias = sourceAlias!
        self.debug = debug!
        self.trackingplanEndpoint = trackingplanEndpoint!
        self.trackingplanConfigEndpoint = trackingplanConfigEndpoint!
        self.ignoreSampling = ignoreSampling!
        self.providerDomains = providerDomains!
        self.batchSize = batchSize
    }
}
