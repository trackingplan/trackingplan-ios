//
//  ReadWriteLock.swift
//  
//
//  Created by Juan Pedro Lozano Baño on 5/7/21.
//

import Foundation

class ReadWriteLock {
    let concurentQueue: DispatchQueue

    init(label: String) {
        self.concurentQueue = DispatchQueue(label: label, qos: .utility, attributes: .concurrent)
    }

    func read(closure: () -> Void) {
        self.concurentQueue.sync {
            closure()
        }
    }
    func write(closure: () -> Void) {
        self.concurentQueue.sync(flags: .barrier, execute: {
            closure()
        })
    }
}
