import XCTest
@testable import Trackingplan
import TrackingplanShared

/// Unit tests for TrackingplanConfig iOS adapter.
///
/// Business logic (withTags, endpoint normalization, etc.) is tested in the shared module.
/// These tests focus on:
/// - Platform-specific defaults (sourceAlias = "ios")
/// - Platform-specific fields (ignoreSampling, batchSize)
/// - Delegation to shared config
/// - iOS-specific static methods
final class TrackingplanConfigTests: XCTestCase {

    func testPlatformSpecificDefaults() {
        let config = TrackingplanConfig(tp_id: "test-tp-id")!

        // Platform-specific default
        XCTAssertEqual(config.sourceAlias, "ios")

        // Platform-specific fields defaults
        XCTAssertFalse(config.ignoreSampling)
        XCTAssertEqual(config.batchSize, 10)
    }

    func testPlatformSpecificFields() {
        // Test ignoreSampling (iOS-specific)
        let configWithIgnoreSampling = TrackingplanConfig(
            tp_id: "test",
            ignoreSampling: true
        )!
        XCTAssertTrue(configWithIgnoreSampling.ignoreSampling)

        // Test batchSize (iOS-specific)
        let configWithBatchSize = TrackingplanConfig(
            tp_id: "test",
            batchSize: 20
        )!
        XCTAssertEqual(configWithBatchSize.batchSize, 20)
    }

    func testPlatformSpecificFieldsPreservedWithTags() {
        let original = TrackingplanConfig(
            tp_id: "test",
            ignoreSampling: true,
            batchSize: 5
        )!

        let updated = original.withTags(["new": "value"])

        // Platform-specific fields should be preserved
        XCTAssertTrue(updated.ignoreSampling)
        XCTAssertEqual(updated.batchSize, 5)
    }

    func testDelegationViaSharedConfig() throws {
        // Test that delegation to shared config works correctly
        let sharedConfig = try TrackingplanShared.TrackingplanConfigBuilder()
            .tpId(tpId: "shared-tp-id")
            .environment(environment: "SHARED_ENV")
            .sourceAlias(alias: "shared-source")
            .tags(tags: ["key": "value"])
            .tracksEndpoint(endpoint: "https://custom-tracks.example.com/")
            .configEndpoint(endpoint: "https://custom-config.example.com/")
            .build()

        let config = TrackingplanConfig(
            sharedConfig: sharedConfig,
            ignoreSampling: true,
            batchSize: 3
        )

        // Verify all delegated properties return expected values
        XCTAssertEqual(config.tp_id, "shared-tp-id")
        XCTAssertEqual(config.environment, "SHARED_ENV")
        XCTAssertEqual(config.sourceAlias, "shared-source")
        XCTAssertEqual(config.tags["key"], "value")
        XCTAssertEqual(config.trackingplanEndpoint, "https://custom-tracks.example.com/")
        XCTAssertEqual(config.trackingplanConfigEndpoint, "https://custom-config.example.com/")

        // Verify platform-specific fields
        XCTAssertTrue(config.ignoreSampling)
        XCTAssertEqual(config.batchSize, 3)
    }

    func testEmptyTpIdReturnsNil() {
        let config = TrackingplanConfig(tp_id: "")
        XCTAssertNil(config, "Config should be nil when tp_id is empty")
    }

    func testDryRunRequiresDebug() {
        // dryRun without debug should fail (returns nil)
        let config = TrackingplanConfig(
            tp_id: "test",
            dryRun: true
        )
        XCTAssertNil(config, "Config should be nil when dryRun is enabled without debug")
    }

    func testDryRunWithDebugDisabledReturnsNil() {
        // dryRun with debug explicitly set to false should fail
        let config = TrackingplanConfig(
            tp_id: "test",
            debug: false,
            dryRun: true
        )
        XCTAssertNil(config, "Config should be nil when dryRun is enabled with debug=false")
    }

    func testResolveTags() {
        // iOS-specific static method
        let inputTags = ["existing": "value"]
        let resolved = TrackingplanConfig.resolveTags(inputTags)

        // Should return at least the input tags
        XCTAssertEqual(resolved["existing"], "value")
    }

    func testGetCurrentTimestamp() {
        // iOS-specific static method
        let before = Date().timeIntervalSince1970
        let timestamp = TrackingplanConfig.getCurrentTimestamp()
        let after = Date().timeIntervalSince1970

        XCTAssertGreaterThanOrEqual(timestamp, before)
        XCTAssertLessThanOrEqual(timestamp, after)
    }
}
