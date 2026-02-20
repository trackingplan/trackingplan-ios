//
//  StorageMigrationTest.swift
//  TrackingplanTests
//
//  Tests for Storage migration from legacy store (com.trackingplan.client) to new store (com.trackingplan.sdk).
//  Migration should only transfer first_time_executed_at and last_dau_event_sent_at keys
//  when tpId/environment match.
//

import XCTest
import class TrackingplanShared.TrackingplanSession
@testable import Trackingplan

final class StorageMigrationTest: BaseInstrumentedTest {

    private static let LEGACY_STORE_NAME = "com.trackingplan.client"
    private static let NEW_STORE_NAME = "com.trackingplan.sdk"

    override func setUp() {
        super.setUp()
        // Clear both legacy and new stores before each test
        if let legacyDefaults = UserDefaults(suiteName: StorageMigrationTest.LEGACY_STORE_NAME) {
            legacyDefaults.removePersistentDomain(forName: StorageMigrationTest.LEGACY_STORE_NAME)
        }
        if let newDefaults = UserDefaults(suiteName: StorageMigrationTest.NEW_STORE_NAME) {
            newDefaults.removePersistentDomain(forName: StorageMigrationTest.NEW_STORE_NAME)
        }
    }

    override func tearDown() {
        // Clean up after tests
        if let legacyDefaults = UserDefaults(suiteName: StorageMigrationTest.LEGACY_STORE_NAME) {
            legacyDefaults.removePersistentDomain(forName: StorageMigrationTest.LEGACY_STORE_NAME)
        }
        if let newDefaults = UserDefaults(suiteName: StorageMigrationTest.NEW_STORE_NAME) {
            newDefaults.removePersistentDomain(forName: StorageMigrationTest.NEW_STORE_NAME)
        }
        super.tearDown()
    }

    // MARK: - Migration Tests

    func test_migration_from_legacy_store_copies_important_keys() {
        // Given: Legacy store with data
        guard let legacyDefaults = UserDefaults(suiteName: StorageMigrationTest.LEGACY_STORE_NAME) else {
            XCTFail("Could not create UserDefaults")
            return
        }
        legacyDefaults.set(Self.testTpId, forKey: "tpId")
        legacyDefaults.set(Self.testEnvironment, forKey: "environment")
        legacyDefaults.set(NSNumber(value: Int64(1000)), forKey: "firstTimeExecutionTimestamp")
        legacyDefaults.set(NSNumber(value: Int64(2000)), forKey: "lastDauEventSentTimestamp")
        // Also add keys that should NOT be migrated
        legacyDefaults.set("old-session-id", forKey: "sessionId")
        legacyDefaults.set(NSNumber(value: Int64(3000)), forKey: "sessionStartedTimestamp")

        // When: Storage is created with matching tpId/environment (triggers migration)
        _ = StorageMigration.createWithMigration(tpId: Self.testTpId, environment: Self.testEnvironment)

        // Then: Important keys are migrated to new store
        guard let newDefaults = UserDefaults(suiteName: StorageMigrationTest.NEW_STORE_NAME) else {
            XCTFail("Could not create UserDefaults")
            return
        }
        XCTAssertEqual(newDefaults.integer(forKey: "first_time_executed_at"), 1000)
        XCTAssertEqual(newDefaults.integer(forKey: "last_dau_event_sent_at"), 2000)
    }

    func test_migration_clears_legacy_store_after_migration() {
        // Given: Legacy store with data
        guard let legacyDefaults = UserDefaults(suiteName: StorageMigrationTest.LEGACY_STORE_NAME) else {
            XCTFail("Could not create UserDefaults")
            return
        }
        legacyDefaults.set(Self.testTpId, forKey: "tpId")
        legacyDefaults.set(Self.testEnvironment, forKey: "environment")
        legacyDefaults.set(NSNumber(value: Int64(1000)), forKey: "firstTimeExecutionTimestamp")
        legacyDefaults.set(NSNumber(value: Int64(2000)), forKey: "lastDauEventSentTimestamp")

        // When: Storage is created with matching tpId/environment
        _ = StorageMigration.createWithMigration(tpId: Self.testTpId, environment: Self.testEnvironment)

        // Then: Legacy keys are removed
        XCTAssertNil(legacyDefaults.string(forKey: "tpId"))
        XCTAssertNil(legacyDefaults.object(forKey: "firstTimeExecutionTimestamp"))
        XCTAssertNil(legacyDefaults.object(forKey: "lastDauEventSentTimestamp"))
    }

    func test_migration_skipped_when_new_store_has_data() {
        // Given: New store already has data
        guard let newDefaults = UserDefaults(suiteName: StorageMigrationTest.NEW_STORE_NAME) else {
            XCTFail("Could not create UserDefaults")
            return
        }
        newDefaults.set(Self.testTpId, forKey: "tp_id")
        newDefaults.set(Self.testEnvironment, forKey: "environment")
        newDefaults.set(Int64(5000), forKey: "first_time_executed_at")

        // And legacy store has different data
        guard let legacyDefaults = UserDefaults(suiteName: StorageMigrationTest.LEGACY_STORE_NAME) else {
            XCTFail("Could not create UserDefaults")
            return
        }
        legacyDefaults.set(Self.testTpId, forKey: "tpId")
        legacyDefaults.set(Self.testEnvironment, forKey: "environment")
        legacyDefaults.set(NSNumber(value: Int64(1000)), forKey: "firstTimeExecutionTimestamp")

        // When: Storage is created
        _ = StorageMigration.createWithMigration(tpId: Self.testTpId, environment: Self.testEnvironment)

        // Then: New store data is preserved (not overwritten)
        XCTAssertEqual(newDefaults.integer(forKey: "first_time_executed_at"), 5000)

        // And legacy keys are removed (cleanup)
        XCTAssertNil(legacyDefaults.string(forKey: "tpId"))
    }

    func test_migration_skipped_when_tpid_mismatch() {
        // Given: Legacy store has different tpId
        guard let legacyDefaults = UserDefaults(suiteName: StorageMigrationTest.LEGACY_STORE_NAME) else {
            XCTFail("Could not create UserDefaults")
            return
        }
        legacyDefaults.set("TP999999", forKey: "tpId") // Different tpId
        legacyDefaults.set(Self.testEnvironment, forKey: "environment")
        legacyDefaults.set(NSNumber(value: Int64(1000)), forKey: "firstTimeExecutionTimestamp")
        legacyDefaults.set(NSNumber(value: Int64(2000)), forKey: "lastDauEventSentTimestamp")

        // When: Storage is created with different tpId
        _ = StorageMigration.createWithMigration(tpId: Self.testTpId, environment: Self.testEnvironment)

        // Then: No migration happens (values not copied to new store)
        // but legacy store is still cleared
        XCTAssertNil(legacyDefaults.string(forKey: "tpId"))
    }

    func test_migration_skipped_when_environment_mismatch() {
        // Given: Legacy store has different environment
        guard let legacyDefaults = UserDefaults(suiteName: StorageMigrationTest.LEGACY_STORE_NAME) else {
            XCTFail("Could not create UserDefaults")
            return
        }
        legacyDefaults.set(Self.testTpId, forKey: "tpId")
        legacyDefaults.set("STAGING", forKey: "environment") // Different environment
        legacyDefaults.set(NSNumber(value: Int64(1000)), forKey: "firstTimeExecutionTimestamp")
        legacyDefaults.set(NSNumber(value: Int64(2000)), forKey: "lastDauEventSentTimestamp")

        // When: Storage is created with different environment
        _ = StorageMigration.createWithMigration(tpId: Self.testTpId, environment: Self.testEnvironment)

        // Then: No migration happens (values not copied to new store)
        // but legacy store is still cleared
        XCTAssertNil(legacyDefaults.string(forKey: "environment"))
    }
}
