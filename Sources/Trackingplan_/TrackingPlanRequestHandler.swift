//
//  TrackingPlanRequestHandler.swift
//  Trackingplan
//
//
//  Created by José Luis Pérez on 24/2/21.
//

import Foundation

public class TrackingPlanRequestHandler: SniffableRequestHandler {
    private var config: TrackingplanConfig
    private var updatingSampleRate = false
    let networkManager: TrackingPlanNetworkManager
   
    public init(config: TrackingplanConfig, queue: DispatchQueue){
        self.config = config
        self.networkManager = TrackingPlanNetworkManager(config: config, queue: queue)
    }
    
    public func sniffRequest(urlRequest: URLRequest) {
        let alternateRequest = URLRequestFactory().createURLRequest(originalUrlRequest: urlRequest)
        networkManager.processRequest(urlRequest: alternateRequest)
    }
}


