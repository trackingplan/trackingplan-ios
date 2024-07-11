//
//  TrackingplanRequestHandler.swift
//  Trackingplan
//

import Foundation

class TrackingplanRequestHandler: SniffableRequestHandler {

    private let networkManager: TrackingplanNetworkManager
    private let serialQueue: DispatchQueue

    init(serialQueue: DispatchQueue, networkManager: TrackingplanNetworkManager) {
        self.networkManager = networkManager
        self.serialQueue = serialQueue
    }

    public func sniffRequest(urlRequest: URLRequest) {
        let alternateRequest = URLRequestFactory().createURLRequest(originalUrlRequest: urlRequest)
        serialQueue.async {
            self.networkManager.processRequest(urlRequest: alternateRequest)
        }
    }
}
