//
//  TrackingplanRequestHandler.swift
//  Trackingplan
//

import Foundation

class TrackingplanRequestHandler: SniffableRequestHandler {
    private var config: TrackingplanConfig
    private var updatingSampleRate = false
    let networkManager: TrackingplanNetworkManager
   
    public init(config: TrackingplanConfig, queue: DispatchQueue){
        self.config = config
        self.networkManager = TrackingplanNetworkManager(config: config, queue: queue)
    }
    
    public func sniffRequest(urlRequest: URLRequest) {
        let alternateRequest = URLRequestFactory().createURLRequest(originalUrlRequest: urlRequest)
        networkManager.processRequest(urlRequest: alternateRequest)
    }
}


