//
//  TrackingplanLog.swift
//  Trackingplan
//
import Foundation
import os.log


//TODO: Unified Logging
class TrackingPlanLogger {
    
    private let tagName: String
    private var enabled: Bool = false
    
    init(tagName: String) {
        self.tagName = tagName
    }
    
    func enableLogging() {
        enabled = true
    }
    
    func debug(message: TrackingplanMessage) {
        
        if !enabled {
            return
        }
        
        switch message {
        case .error(let code, let message):
            print("\(tagName) ERROR Code: \(code), Message: \(message)")
        case .message(let msg):
            print("\(tagName) DEBUG \(msg)")
        case .success:
            print("\(tagName) DEBUG Success")
        }
    }
}
