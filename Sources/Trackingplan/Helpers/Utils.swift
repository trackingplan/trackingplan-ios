//
//  Utils.swift
//
//
//  Created by José Padilla López on 10/7/24.
//

import Foundation
import UIKit

class Utils {
    
    static func startBackgroundTask(name: String, expirationHandler: (() -> Void)? = nil) -> UIBackgroundTaskIdentifier {
        
        var taskId: UIBackgroundTaskIdentifier = .invalid
        
        taskId = UIApplication.shared.beginBackgroundTask(withName: name) {
            // This block is executed if the background task expires
            expirationHandler?()
            self.endBackgroundTask(taskId)
        }
        
        return taskId
    }
    
    static func endBackgroundTask(_ taskId: UIBackgroundTaskIdentifier) {
        if taskId != .invalid {
            UIApplication.shared.endBackgroundTask(taskId)
        }
    }
}
