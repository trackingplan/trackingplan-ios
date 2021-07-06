//
//  File.swift
//  
//
//  Created by Juan Pedro Lozano Baño on 13/6/21.
//

import Foundation
import os.log

typealias Logger = TrackingPlanLogging

//TODO: Unified Logging
extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let sniffLog = OSLog(subsystem: subsystem, category: "sniffing")
}

struct TrackingPlanLogging {
    static func log(error: TrackingPlanError) {
        switch error {
        case .debugError(_, _):
            os_log("", log: OSLog.sniffLog, type: .error)

        default:
            os_log("Unknow Error", log: OSLog.sniffLog, type: .error)
        }
    }
}
