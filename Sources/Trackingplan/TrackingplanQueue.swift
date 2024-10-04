//
//  TrackingplanTrack.swift
//  Trackingplan
//

import Foundation
import UIKit


class TrackingplanQueue {
        
    public static let sharedInstance = TrackingplanQueue()
    
    let storageQueue = DispatchQueue(label: "com.trackingplan.storage", attributes: .concurrent)
    let logger: TrackingPlanLogger
    
    private var _storage: [TrackingplanTrack]
    
    var storage: [TrackingplanTrack] {
        get {
            storageQueue.sync {
                return _storage
            }
        }
        set {
            storageQueue.async(flags: .barrier) {
                self._storage = newValue
            }
        }
    }
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    init() {
        self._storage = [TrackingplanTrack]()
        logger = TrackingplanManager.logger
    }
    
    func taskCount() -> Int {
        return self.storage.count
    }
    
    func enqueue(_ element: TrackingplanTrack) -> Void {
        semaphore.wait()
        self.storage.append(element)
        semaphore.signal()
    }
    
    func retrieveRaw() -> [[String:Any]] {
        defer {
            semaphore.signal()
        }
        semaphore.wait()
        let tracks = storage.map({$0.dictionary!})
        storage.removeAll()
        return tracks
    }
    
    func cleanUp() {
        semaphore.wait()
        storage.removeAll()
        semaphore.signal()
    }
}


struct TrackingplanTrack: Codable {
    
    let provider: String
    let request: TrackingplanTrackRequest?
    let context: TrackingplanTrackContext
    let tp_id: String
    let source_alias: String
    let environment: String
    let tags: Dictionary<String, String>?
    let ts: Int64
    let sdk: String
    let sdk_version: String
    let sampling_rate: Int
    let session_id: String
    let debug: Bool
    
    init(request: TrackingplanTrackRequest, provider: String, sampleRate: Int, sessionId: String, config: TrackingplanConfig) {
        self.provider = provider
        self.request = request
        self.context = TrackingplanTrackContext()
        self.tp_id = config.tp_id
        self.source_alias = config.sourceAlias
        self.environment = config.environment
        self.ts = Int64(Date().timeIntervalSince1970 * 1000) // Assume that raw track is created when the request is intercepted
        self.sdk = TrackingplanManager.sdk
        self.sdk_version = TrackingplanManager.sdkVersion
        self.sampling_rate = sampleRate
        self.session_id = sessionId
        self.debug = config.debug
        
        // Optional tags
        if !config.tags.isEmpty {
            self.tags = config.tags
        } else {
            self.tags = nil
        }
    }
}

struct TrackingplanTrackContext: Codable {
    
    let app_version: String
    let app_name: String
    let app_build_number: String
    let language: String
    let platform: String
    let device: String
    
    init() {
        self.app_version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.app_name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        self.app_build_number = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        self.language = Locale.preferredLanguages.first ?? "unknown"
        self.platform = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        
        if ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] == nil {
            self.device = UIDevice.current.name
        } else {
            self.device = "\(UIDevice.current.name) (simulator)"
        }
    }
}

struct TrackingplanTrackRequest: Codable {
    
    public enum RequestDataType: String, Codable {
        case string
        case gzip_base64
        case unknown
    }
    
    let endpoint: String
    let method: String?
    let post_payload: String?
    var post_payload_type: String = RequestDataType.string.rawValue
    let request_id: String
    
    init(urlRequest: URLRequest) {
        // The original provider endpoint URL
        self.endpoint = urlRequest.url!.absoluteString
        // The request method. It’s not just POST & GET, but the info needed to inform the parsers how to decode the payload within that provider, e.g. Beacon.
        self.method = urlRequest.httpMethod!
        // The payload, in its original form. If it’s a POST request, the raw payload, if it’s a GET, the querystring (are there other ways?).
        let requestHttpBody = urlRequest.getHttpBody()
        self.post_payload = requestHttpBody?.body
        self.post_payload_type =  requestHttpBody?.dataType.rawValue ?? RequestDataType.string.rawValue
        self.request_id = UUID().uuidString.lowercased()
    }
    
    // Used to create Trackingplan events
    init?(eventName: String) {
        let jsonObject: [String: String] = ["event_name": "new_dau"]
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            self.post_payload = jsonString
            self.post_payload_type = RequestDataType.string.rawValue
        } else {
            return nil
        }
        self.endpoint = "TRACKINGPLAN"
        self.method = "POST"
        self.request_id = UUID().uuidString.lowercased()
    }
}
