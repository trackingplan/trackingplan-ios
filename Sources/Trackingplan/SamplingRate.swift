//
//  File.swift
//  
//
//  Created by José Padilla López on 5/7/24.
//

import Foundation

class SamplingRate : CustomStringConvertible {
    
    static let samplingRateLifeTime: Int64 = 24 * 3600 * 1000; // 24 hours
    
    let value: Int
    let downloadedAt: Int64
    let trackingEnabled: Bool

    
    // Used to create a new sampling rate after downloading it
    init(samplingRate: Int) {
        self.value = samplingRate
        downloadedAt = Int64(Date().timeIntervalSince1970 * 1000)
        trackingEnabled = Float.random(in: 0.0...1.0) <= (1 / Float(samplingRate))
    }
    
    // Used to restore sampling rate from storage
    init(samplingRate: Int, downloadedAt: Int64, trackingEnabled: Bool) {
        self.value = samplingRate
        self.downloadedAt = downloadedAt
        self.trackingEnabled = trackingEnabled
    }
    
    func hasExpired() -> Bool {
        let currentTimeMillis = Int64(Date().timeIntervalSince1970 * 1000)
        return currentTimeMillis >= downloadedAt + SamplingRate.samplingRateLifeTime
    }
    
    // CustomStringConvertible conformance
    var description: String {
        return "SamplingRate(value: \(value), trackingEnabled: \(trackingEnabled))"
    }
}
