//
//  TrackingplanTrack.swift
//  Trackingplan
//

import Foundation


class TrackingplanQueue {
    
    static let delay: DispatchTime = DispatchTime.now()  + 0.25
    static let defaultArchiveKey = "com.trackingplan.store"
    static let archiveKey = "trackingplanQueue"
    
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
    
    fileprivate let validArchive: Bool = {
        // Check is last archive tracks ar older than 20 min
        if let lastUnarchiveDate = UserDefaultsHelper.getData(type: Int.self, forKey: .lastArchivedDate) {
            return Int(TrackingplanConfig.getCurrentTimestamp())  < lastUnarchiveDate + 1200
        }
        return false
    }()
    
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
    
    func dequeue() -> TrackingplanTrack? {
        semaphore.wait()
        defer { semaphore.signal() }
        return self.storage.isEmpty ? nil : self.storage.removeFirst()
    }
    
    
    func archive() {
        UserDefaults.standard.encode(for: self.storage, using: TrackingplanQueue.defaultArchiveKey)
        // Save timestamp for archive
        UserDefaultsHelper.setData(value: Int(TrackingplanConfig.getCurrentTimestamp()), key: .lastArchivedDate)
        logger.debug(message: TrackingplanMessage.message("Storage archive success count: \(self.storage.count) "))
    }
    
    func unarchive() {
        guard let tracksArray = UserDefaults.standard.decode(for: [TrackingplanTrack].self, using: TrackingplanQueue.defaultArchiveKey), validArchive else {
            return
        }
        
        logger.debug(message: TrackingplanMessage.message("Storage unarchive success count: \(tracksArray.count) "))
        self.storage.append(contentsOf:tracksArray)
        discardArchive()
    }
    
    func discardArchive() {
        UserDefaults.standard.setValue(nil, forKey: TrackingplanQueue.defaultArchiveKey)
        // Remove timestamp for archive
        UserDefaultsHelper.removeData(key: .lastArchivedDate)
    }
    
    func retrieveRaw() -> [[String:Any]]? {
        defer {
            self.semaphore.signal()
        }
        self.semaphore.wait()
        return self.storage.map({$0.dictionary!})
    }
    
    func cleanUp() {
        self.semaphore.wait()
        self.storage.removeAll()
        self.semaphore.signal()
        UserDefaults.standard.setValue(nil, forKey: TrackingplanQueue.defaultArchiveKey)
    }
}


struct TrackingplanTrack: Codable {
    
    let provider: String
    let request: TrackingplanTrackRequest?
    let context: TrackingplanTrackContext
    let tp_id: String
    let source_alias: String
    let environment: String
    let tags: Dictionary <String, String>
    let ts: Int64
    let sdk: String
    let sdk_version: String
    let sampling_rate: Int
    let debug: Bool
    
    init(urlRequest: URLRequest, provider: String, sampleRate: Int, config: TrackingplanConfig) {
        self.provider = provider
        self.request = TrackingplanTrackRequest(urlRequest: urlRequest)
        self.context = TrackingplanTrackContext()
        self.tp_id = config.tp_id
        self.source_alias = config.sourceAlias
        self.environment = config.environment
        self.tags = config.tags
        self.ts = Int64(Date().timeIntervalSince1970 * 1000) // Assume that raw track is created when the request is intercepted
        self.sdk = TrackingplanManager.sdk
        self.sdk_version = TrackingplanManager.sdkVersion
        self.sampling_rate = sampleRate
        self.debug = config.debug
    }
}


struct TrackingplanTrackContext: Codable {
    
    let app_version: String
    let app_name: String
    let app_build_number: String
    
    init() {
        self.app_version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.app_name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        self.app_build_number = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
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
        self.request_id = UUID().uuidString
    }
}

struct TrackingplanSampleRate: Codable {
    
    var sampleRate: Int
    var sampleRateTimestamp: TimeInterval
    
    func validSampleRate() -> Int {
        return (TrackingplanConfig.getCurrentTimestamp() < sampleRateTimestamp + 86400) ? self.sampleRate : 0
    }
}
