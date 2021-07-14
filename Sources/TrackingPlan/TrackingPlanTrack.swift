//
//  File.swift
//  
//
//  Created by Juan Pedro Lozano Baño on 5/7/21.
//

import Foundation


public class TrackingPlanQueue {
    static let delay: DispatchTime = DispatchTime.now() + 0.25
    static let archiveNotificationName = Notification.Name("on-selected-skin")
    static let defaultArchiveKey = "com.trackingplan.store"
    static let archiveKey = "trackingPlanQueue"
    private var storage: [TrackingPlanTrack]
    let readWriteLock = ReadWriteLock(label: "com.trackingPlan.globallock")

    fileprivate let validArchive: Bool = {
        //Check is last archive tracks ar older than 24h
        if let lastUnarchiveDate = UserDefaultsHelper.getData(type: Int.self, forKey: .lastArchivedDate) {
            return Int(TrackingplanConfig.getCurrentTimestamp())  < lastUnarchiveDate + 86400
        }
        return false
    }()

    init()
    {
        self.storage = [TrackingPlanTrack]()
        //Build previous storage
        unarchive()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(archive),
                                               name: TrackingPlanQueue.archiveNotificationName,
                                       object: nil)
    }
    
    
    func taskCount() -> Int {
        return self.storage.count
    }
    func enqueue(_ element: TrackingPlanTrack) -> Void
    {
        self.readWriteLock.write {
            self.storage.append(element)

        }
    }

    func dequeue() -> TrackingPlanTrack?
    {
        return self.storage.removeFirst()
    }
    
    
    @objc func archive() {
        //Archive tracks
        UserDefaults.standard.encode(for: self.storage, using: TrackingPlanQueue.defaultArchiveKey)
        //Save timestamp for archive
        UserDefaultsHelper.setData(value: Int(TrackingplanConfig.getCurrentTimestamp()), key: .lastArchivedDate)
        Logger.debug(message: TrackingPlanMessage.message("Storage archive success count: \(self.storage.count) "))

    }
    
    public func unarchive() {
        guard let tracksArray = UserDefaults.standard.decode(for: [TrackingPlanTrack].self, using: TrackingPlanQueue.defaultArchiveKey), validArchive else {
            return
        }
        
        Logger.debug(message: TrackingPlanMessage.message("Storage unarchive success count: \(tracksArray.count) "))
        self.storage.append(contentsOf:tracksArray)
        //Cleanup Tracks archive
        UserDefaults.standard.setValue(nil, forKey: TrackingPlanQueue.defaultArchiveKey)
        //Remove timestamp for archived tracks
        UserDefaultsHelper.removeData(key: .lastArchivedDate)

    }
    
    func retrieveRaw() -> [[String:Any]]? {
        return self.storage.map({$0.dictionary!})
    }
    
    func cleanUp() {
        readWriteLock.write {
            self.storage.removeAll()

        }
        UserDefaults.standard.setValue(nil, forKey: TrackingPlanQueue.defaultArchiveKey)
    }
}



struct TrackingPlanTrack: Codable {
    enum TrackKeys: String, CodingKey {
        case provider
        case request
        case context
        case tp_id
        case source_alias
        case environment
        case sdk
        case sdk_version
        case samplingRate
        case debug
    }
    
    let provider: String
    let request: TrackingPlanTrackRequest?
    let context = TrackingPlanTrackContext()
    let tp_id: String
    let source_alias: String
    let environment: String
    let sdk: String
    let sdk_version: String
    let samplingRate: Int
    let debug: Bool
    
    init (urlRequest: URLRequest, provider: String, sampleRate: Int, config: TrackingplanConfig) {
        self.provider = provider
        self.request = TrackingPlanTrackRequest(urlRequest: urlRequest)
        self.tp_id = config.tp_id
        self.source_alias = config.sourceAlias
        self.environment = config.environment
        self.sdk = TrackingplanManager.sdk
        self.sdk_version = TrackingplanManager.sdkVersion
        self.samplingRate = sampleRate
        self.debug = config.debug
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TrackKeys.self)
        self.provider = try container.decode(String.self, forKey: .provider)
        self.request = try container.decodeIfPresent(TrackingPlanTrackRequest.self, forKey: .request)
        self.tp_id = try container.decode(String.self, forKey: .tp_id)
        self.source_alias = try container.decode(String.self, forKey: .source_alias)
        self.environment = try container.decode(String.self, forKey: .environment)
        self.sdk_version = try container.decode(String.self, forKey: .sdk_version)
        self.sdk = try container.decode(String.self, forKey: .sdk)
        self.samplingRate = try container.decode(Int.self, forKey: .samplingRate)
        self.debug = try container.decode(Bool.self, forKey: .debug)

    }
}


struct TrackingPlanTrackContext: Codable {
    enum ContextTrackKeys: String, CodingKey {
        case appVersionLong
        case appName
        case appBuildNumber
    }
    
    let appVersionLong: String
    let app_name: String
    let app_build_number: String

    init() {
        self.appVersionLong = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        self.app_name = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        self.app_build_number = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    }

}

public struct TrackingPlanTrackRequest: Codable {
    enum RequestTrackKeys: String, CodingKey {
        case endpoint
        case method
        case post_payload
        case post_payload_type
    }
    
    public enum RequestDataType: String, Codable {
        case string
        case gzip_base64
        case unknown
    }
    
    let endpoint: String
    let method: String?
    let post_payload: String?
    var post_payload_type: String = RequestDataType.string.rawValue
    
    public init(urlRequest: URLRequest) {
        // The original provider endpoint URL
        self.endpoint = urlRequest.url!.absoluteString
        // The request method. It’s not just POST & GET, but the info needed to inform the parsers how to decode the payload within that provider, e.g. Beacon.
        self.method = urlRequest.httpMethod!
        // The payload, in its original form. If it’s a POST request, the raw payload, if it’s a GET, the querystring (are there other ways?).
        let requestHttpBody = urlRequest.getHttpBody()
        self.post_payload = requestHttpBody?.body
        self.post_payload_type =  requestHttpBody?.dataType.rawValue ?? RequestDataType.string.rawValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RequestTrackKeys.self)
        self.endpoint = try container.decode(String.self, forKey: .endpoint)
        self.method = try container.decodeIfPresent(String.self, forKey: .method)
        self.post_payload = try container.decodeIfPresent(String.self, forKey: .post_payload)
    }
   
}

public struct TrackingPlanSampleRate: Codable {
    var sampleRate: Int
    var sampleRateTimestamp: TimeInterval
    func validSampleRate() -> Int {
        return (TrackingplanConfig.getCurrentTimestamp() < sampleRateTimestamp + 86400) ? self.sampleRate : 0
    }
}
