//
//  File.swift
//  
//
//  Created by Juan Pedro Lozano Baño on 5/7/21.
//

import Foundation

public class TrackingPlanQueue {
    static let delay: DispatchTime = DispatchTime.now() + 0.25
    static let defaultArchiveKey = "com.trackingplan.store"
    static let archiveKey = "trackingPlanQueue"
    private var storage: [TrackingPlanTrack]
    
    init()
    {
        self.storage = [TrackingPlanTrack]()
    }
    
    
    func taskCount() -> Int {
        return self.storage.count
    }
    func enqueue(_ element: TrackingPlanTrack) -> Void
    {
        self.storage.append(element)
    }
    
    func dequeue() -> TrackingPlanTrack?
    {
        return self.storage.removeFirst()
    }
    
    func archive() {
        var storageDict = [String : Any]()
        let tracks = self.storage.map{$0.rawTrack}
        storageDict[TrackingPlanQueue.archiveKey] = tracks
        UserDefaults.standard.setValue(tracks, forKey: TrackingPlanQueue.defaultArchiveKey)
    }
    
    public func unarchive() {
        let current = UserDefaults.standard.object(forKey: TrackingPlanQueue.defaultArchiveKey) as? [String : Any]
        var savedTracks: [TrackingPlanTrack] = []
        current?.forEach({ (key: String, value: Any) in
            savedTracks.append(TrackingPlanTrack(rawTrack: [key:value]))
        })
        self.storage.append(contentsOf: savedTracks)
        UserDefaults.standard.setValue(nil, forKey: TrackingPlanQueue.defaultArchiveKey)
        
    }
    
    func retrieveRaw() -> [[String:Any]]? {
        defer {
            self.storage.removeAll()
        }
        return self.storage.map({$0.rawTrack})
    }
}

class TrackingPlanTrack {
    public let rawTrack: [String : Any]
    
    init(rawTrack: [String: Any]) {
        self.rawTrack = rawTrack
    }
    
    init (urlRequest: URLRequest, provider: String, sampleRate: Int, config: TrackingplanConfig) {
        self.rawTrack =  [
            // Normalized provider name (extracted from domain/regex => provider hash table).
            "provider": provider,
            
            "request": [
                // The original provider endpoint URL
                "endpoint": urlRequest.url!.absoluteString,
                // The request method. It’s not just POST & GET, but the info needed to inform the parsers how to decode the payload within that provider, e.g. Beacon.
                "method": urlRequest.httpMethod as Any,
                // The payload, in its original form. If it’s a POST request, the raw payload, if it’s a GET, the querystring (are there other ways?).
                "post_payload": urlRequest.getHttpBody() as Any,
            ] ,
            "context": [
                "app_version_long": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String,
                "app_name": Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String,
                "app_build_number": Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
                
                // Information that is extracted in run time that can be useful. IE. UserAgent, URL, etc. it varies depending on the platform. Can we standardize it?
            ],
            // A key that identifies the customer. It’s written by the developer on the SDK initialization.
                "tp_id": config.tpId,
            // An optional alias that identifies the source. It’s written by the developer on the SDK initialization.
                "source_alias": config.sourceAlias,
            // An optional environment. It’s written by the developer on the SDK initialization. Useful for the developer testing. Can be "PRODUCTION" or "TESTING".
                "environment": config.environment,
            // The used sdk. It’s known by the sdk itself.
            "sdk": TrackingplanManager.sdk,
            // The SDK version, useful for implementing different parsing strategies. It’s known by the sdk itself.
            "sdk_version": TrackingplanManager.sdkVersion,
            // The rate at which this specific track has been sampled.
            "sampling_rate": sampleRate,
            // Debug mode. Makes every request return and console.log the parsed track.
                "debug": config.debug
        ]
    }

        
}
