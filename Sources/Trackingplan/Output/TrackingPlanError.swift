//
//  File.swift
//  
//
//  Created by Juan Pedro Lozano Baño on 13/6/21.
//

import Foundation


//TODO: Error type management
enum TrackingplanError: Error {
    case tokenExpired
    case tokenInvalid
    case debugError(String, Error)
    case genericError(Error)
        
    var stringDescription: String {
        return String(describing: self)
    }
}

enum TrackingplanMessage{
    case message(String)
    case error(String, String)
    case success
}
