//
//  File.swift
//  
//
//  Created by José Padilla López on 5/7/24.
//

import Foundation

enum UserDefaultKey: String, CaseIterable {
    case tpId
    case environment
    case sessionId
    case sessionStartedTimestamp
    case sessionSampleRate
    case sessionTrackingEnabled
    case sessionLastActivityTimestamp
    case sampleRate
    case sampleRateTimestamp
    case trackingEnabled
    case lastDauEventSentTimestamp
    case firstTimeExecutionTimestamp
}

class Storage {
    
    static let suiteName = "com.trackingplan.client"
    
    let defaults: UserDefaults
    
    init?(tpId: String, environment: String) {
        guard let defaults = UserDefaults(suiteName: Storage.suiteName) else {
            return nil
        }
        
        self.defaults = defaults
        
        if !isSameTpIdAndEnvironment(tpId: tpId, environment: environment) {
            defaults.removePersistentDomain(forName: Storage.suiteName)
            defaults.set(tpId, forKey: UserDefaultKey.tpId.rawValue)
            defaults.set(environment, forKey: UserDefaultKey.environment.rawValue)
        }
    }
    
    func loadSession() -> TrackingplanSession? {
        
        guard let sessionId = defaults.string(forKey: UserDefaultKey.sessionId.rawValue), !sessionId.isEmpty else {
            return nil
        }
        
        let samplingRate = defaults.integer(forKey: UserDefaultKey.sessionSampleRate.rawValue)
        if samplingRate == 0 {
            return nil
        }
        
        let trackingEnabled = defaults.bool(forKey: UserDefaultKey.sessionTrackingEnabled.rawValue)
        
        guard let createdAt = defaults.object(forKey: UserDefaultKey.sessionStartedTimestamp.rawValue) as? NSNumber else {
            return nil
        }
        
        guard let lastActivity = defaults.object(forKey: UserDefaultKey.sessionLastActivityTimestamp.rawValue) as? NSNumber else {
            return nil
        }
        
        return TrackingplanSession(
            sessionId: sessionId,
            samplingRate: samplingRate,
            trackingEnabled: trackingEnabled,
            createdAt: createdAt.int64Value,
            lastActivityTime: lastActivity.int64Value
        )
    }
    
    func saveSession(session: TrackingplanSession) {
        defaults.set(session.sessionId, forKey: UserDefaultKey.sessionId.rawValue)
        defaults.set(session.samplingRate, forKey: UserDefaultKey.sessionSampleRate.rawValue)
        defaults.set(session.trackingEnabled, forKey: UserDefaultKey.sessionTrackingEnabled.rawValue)
        defaults.set(NSNumber(value: session.createdAt), forKey: UserDefaultKey.sessionStartedTimestamp.rawValue)
        defaults.set(NSNumber(value: session.lastActivityTime), forKey: UserDefaultKey.sessionLastActivityTimestamp.rawValue)
    }
    
    func loadSamplingRate() -> SamplingRate? {
        
        let samplingRate = defaults.integer(forKey: UserDefaultKey.sampleRate.rawValue)
        if samplingRate == 0 {
            return nil
        }
        
        guard let downloadedAt = defaults.object(forKey: UserDefaultKey.sampleRateTimestamp.rawValue) as? NSNumber else {
            return nil
        }
        
        let trackingEnabled = defaults.bool(forKey: UserDefaultKey.trackingEnabled.rawValue)
        
        return SamplingRate(samplingRate: samplingRate, downloadedAt: downloadedAt.int64Value, trackingEnabled: trackingEnabled)
    }
    
    func saveSamplingRate(samplingRate: SamplingRate) {
        defaults.set(samplingRate.value, forKey: UserDefaultKey.sampleRate.rawValue)
        defaults.set(samplingRate.trackingEnabled, forKey: UserDefaultKey.trackingEnabled.rawValue)
        defaults.set(NSNumber(value: samplingRate.downloadedAt), forKey: UserDefaultKey.sampleRateTimestamp.rawValue)
    }
    
    func isFirstTimeExecution() -> Bool {
        guard let _ = defaults.object(forKey: UserDefaultKey.firstTimeExecutionTimestamp.rawValue) as? NSNumber else {
            return true
        }
        return false
    }
    
    func saveFirstTimeExecution() {
        let currentTimeMillis = Int64(Date().timeIntervalSince1970 * 1000)
        defaults.set(NSNumber(value: currentTimeMillis), forKey: UserDefaultKey.firstTimeExecutionTimestamp.rawValue)
    }
    
    func wasLastDauSent24hAgo() -> Bool {
        guard let lastDauEventSentAt = defaults.object(forKey: UserDefaultKey.lastDauEventSentTimestamp.rawValue) as? NSNumber else {
            return true
        }
        return lastDauEventSentAt.int64Value + 86400 * 1000 < Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func saveLastDauEventSentTime() {
        let currentTimeMillis = Int64(Date().timeIntervalSince1970 * 1000)
        defaults.set(NSNumber(value: currentTimeMillis), forKey: UserDefaultKey.lastDauEventSentTimestamp.rawValue)
    }
    
    private func isSameTpIdAndEnvironment(tpId: String, environment: String) -> Bool {
        
        guard let storedTpId = defaults.string(forKey: UserDefaultKey.tpId.rawValue) else {
            return false
        }
        
        guard let storedEnvironment = defaults.string(forKey: UserDefaultKey.environment.rawValue) else {
            return false
        }
        
        return storedTpId == tpId && storedEnvironment == environment
    }
}
