//
//  File.swift
//  
//
//  Created by José Padilla López on 5/7/24.
//

import Foundation

class TrackingplanSession : CustomStringConvertible {
    
    static let maxIdleDuration: Int64 = 30 * 60 * 1000 // 30 minutes
    
    let sessionId: String
    let samplingRate: Int
    let trackingEnabled: Bool
    let createdAt: Int64
    var lastActivityTime: Int64
    let isNew: Bool
    
    // Used to create new sessions
    init(samplingRate: Int, trackingEnabled: Bool) {
        sessionId = UUID().uuidString.lowercased()
        self.samplingRate = samplingRate
        self.trackingEnabled = trackingEnabled
        createdAt = Int64(Date().timeIntervalSince1970 * 1000)
        lastActivityTime = Int64(ProcessInfo.processInfo.systemUptime * 1000)
        isNew = true
    }
    
    // Used to restore session objects from storage
    init(sessionId: String, samplingRate: Int, trackingEnabled: Bool, createdAt: Int64, lastActivityTime: Int64) {
        self.sessionId = sessionId
        self.samplingRate = samplingRate
        self.trackingEnabled = trackingEnabled
        self.createdAt = createdAt
        self.lastActivityTime = lastActivityTime
        isNew = false
    }
    
    func hasExpired() -> Bool {
        return getIdleDuration() >= TrackingplanSession.maxIdleDuration
    }
    
    func updateLastActivity() -> Bool {
        let elapsedTimeSinceBoot = Int64(ProcessInfo.processInfo.systemUptime * 1000)
        
        if lastActivityTime > elapsedTimeSinceBoot || elapsedTimeSinceBoot > lastActivityTime + 60 * 1000 {
            lastActivityTime = elapsedTimeSinceBoot
            return true
        }
        
        return false
    }
    
    private func getIdleDuration() -> Int64 {
        
        let elapsedTimeSinceBoot = Int64(ProcessInfo.processInfo.systemUptime * 1000)
        
        // Session expires when device reboots since systemUptime gets restarted
        if lastActivityTime > elapsedTimeSinceBoot {
            return Int64.max
        }
        
        return elapsedTimeSinceBoot - lastActivityTime
    }
    
    // CustomStringConvertible conformance
    var description: String {
        return "TrackingplanSession(sessionId: \(sessionId), trackingEnabled: \(trackingEnabled))"
    }
}
