//
//  TrackingplanConfig.swift
//  Trackingplan
//

import Foundation
import TrackingplanShared

/// Immutable configuration for Trackingplan iOS SDK.
/// Wraps the shared TrackingplanConfig and adds iOS-specific configuration.
public struct TrackingplanConfig {

    // Shared configuration (contains common fields)
    private let sharedConfig: TrackingplanShared.TrackingplanConfig

    // iOS-specific fields
    public let ignoreSampling: Bool
    public let batchSize: Int

    // MARK: - Computed properties delegating to shared config

    // swiftlint:disable:next identifier_name
    public var tp_id: String { sharedConfig.tpId }
    public var environment: String { sharedConfig.environment }
    public var tags: [String: String] {
        Dictionary(uniqueKeysWithValues: sharedConfig.tags.map { ($0.key, $0.value) })
    }
    public var sourceAlias: String { sharedConfig.sourceAlias }
    public var debug: Bool { sharedConfig.debug }
    public var testing: Bool { sharedConfig.testing }
    public var dryRun: Bool { sharedConfig.dryRun }
    public var trackingplanEndpoint: String { sharedConfig.tracksEndpoint }
    public var trackingplanConfigEndpoint: String { sharedConfig.configEndpoint }
    public var providerDomains: [String: String] {
        Dictionary(uniqueKeysWithValues: sharedConfig.providerDomains.map { ($0.key, $0.value) })
    }

    // MARK: - Initializers

    /// Initialize from shared config with iOS-specific fields
    internal init(
        sharedConfig: TrackingplanShared.TrackingplanConfig,
        ignoreSampling: Bool = false,
        batchSize: Int = 10
    ) {
        self.sharedConfig = sharedConfig
        self.ignoreSampling = ignoreSampling
        self.batchSize = batchSize
    }

    /// Convenience initializer maintaining backward compatibility
    /// Returns nil if tp_id is empty or if dryRun is enabled without debug
    // swiftlint:disable identifier_name
    public init?(
        tp_id: String,
        environment: String = "PRODUCTION",
        tags: [String: String] = [:],
        sourceAlias: String = "ios",
        debug: Bool = false,
        testing: Bool = false,
        dryRun: Bool = false,
        trackingplanEndpoint: String = TrackingplanShared.TrackingplanConfig.companion.DEFAULT_TRACKS_ENDPOINT,
        trackingplanConfigEndpoint: String = TrackingplanShared.TrackingplanConfig.companion.DEFAULT_CONFIG_ENDPOINT,
        ignoreSampling: Bool = false,
        providerDomains: [String: String] = [:],
        batchSize: Int = 10
    ) {
        do {
            let shared = try TrackingplanShared.TrackingplanConfigBuilder()
                .tpId(tpId: tp_id)
                .environment(environment: environment)
                .sourceAlias(alias: sourceAlias)
                .tags(tags: tags)
                .providerDomains(domains: providerDomains)
                .debug(enabled: debug)
                .testing(enabled: testing)
                .dryRun(enabled: dryRun)
                .tracksEndpoint(endpoint: trackingplanEndpoint)
                .configEndpoint(endpoint: trackingplanConfigEndpoint)
                .build()

            self.init(sharedConfig: shared, ignoreSampling: ignoreSampling, batchSize: batchSize)
        } catch {
            return nil
        }
    }
    // swiftlint:enable identifier_name

    // MARK: - Methods

    /// Creates a new config with updated tags
    public func withTags(_ newTags: [String: String], replace: Bool = false) -> TrackingplanConfig {
        let updatedShared = sharedConfig.withTags(newTags: newTags, replace: replace)
        return TrackingplanConfig(
            sharedConfig: updatedShared,
            ignoreSampling: self.ignoreSampling,
            batchSize: self.batchSize
        )
    }

    public func sampleRateURL() -> URL? {
        return URL(string: sharedConfig.sampleRateUrl())
    }
}

public enum TrackingplanTag: String, CaseIterable {

    case tagName = "TP_TAG_"
    case environment = "TP_ENVIRONMENT"
    case testSessionName = "TP_TAG_test_session_name"

    /// Create an argument Tracking Plan tag that will be used as pair KEY and VALUE.
    /// This should come from a [String : String] dictionary such ProcessInfo().environment
    /// - Parameters:
    ///     - value: original string from the source
    ///
    /// - Returns: preform string tag to be recognized by Tracking Plan.
    public func keyWithName(_ value: String) -> String {
        return TrackingplanTag.tagName.rawValue + value
    }
}

// Basic convenience init and sample rate
extension TrackingplanConfig {

    @discardableResult
    static func resolveTags(_ tags: [String: String]) -> [String: String] {
        var tpTags = tags
        // Environment tags
        ProcessInfo().environment.forEach { key, value in
            if key.starts(with: TrackingplanTag.tagName.rawValue) {
                tpTags[key.replacingOccurrences(of: TrackingplanTag.tagName.rawValue, with: "")] = value
            }
        }

        return tpTags
    }

    static func resolveEnvironment() -> String? {
        var environment: String?
        ProcessInfo().environment.forEach { key, value in
            if key == TrackingplanTag.environment.rawValue {
                environment = value
            }
        }
        return environment
    }

    static func resolveRegressionTesting() -> Bool {
        if let sessionName = ProcessInfo().environment[TrackingplanTag.testSessionName.rawValue], !sessionName.isEmpty {
            return true
        }
        return false
    }

    static func getCurrentTimestamp() -> TimeInterval {
        Date().timeIntervalSince1970
    }
}
