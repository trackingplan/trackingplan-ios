//
//  TrackingPlanLogger.swift
//  Trackingplan
//
import Foundation
import TrackingplanShared

class TrackingPlanLogger {

    private enum LogLevel: String {
        case verbose = "VERBOSE"
        case debug = "DEBUG"
        case error = "ERROR"

    }

    private let tagName: String
    private var enabled: Bool = false
    private var loggers: [TrackingplanShared.Logger] = []
    private let loggersLock = NSLock()

    init(tagName: String) {
        self.tagName = tagName
        // Initialize with PlatformLogger by default
        self.loggers = [TrackingplanShared.PlatformLogger()]
    }

    func enableLogging() {
        enabled = true
    }

    /// Add an additional logger to receive log messages
    func addLogger(_ logger: TrackingplanShared.Logger) {
        loggersLock.lock()
        defer { loggersLock.unlock() }
        loggers.append(logger)
    }

    /// Remove a previously added logger
    func removeLogger(_ logger: TrackingplanShared.Logger) {
        loggersLock.lock()
        defer { loggersLock.unlock() }
        loggers.removeAll { $0 === logger }
    }

    func verbose(_ msg: String) {
        log(msg, level: .verbose) { $0.v(msg: msg) }
    }

    func debug(_ msg: String) {
        log(msg, level: .debug) { $0.d(msg: msg) }
    }

    func error(_ msg: String) {
        log(msg, level: .error) { $0.e(msg: msg) }
    }

    private func log(_ msg: String, level: LogLevel, notify: (TrackingplanShared.Logger) -> Void) {
        guard enabled else { return }

        loggersLock.lock()
        let currentLoggers = loggers
        loggersLock.unlock()

        for logger in currentLoggers {
            notify(logger)
        }
    }
}
