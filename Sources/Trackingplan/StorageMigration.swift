//
//  StorageMigration.swift
//  Trackingplan
//
//  Created by Claude Code
//

import Foundation
import TrackingplanShared

class StorageMigration {

    private static let LEGACY_STORE_NAME = "com.trackingplan.client"

    /**
     * Creates a Storage instance and migrates legacy data if needed.
     * This replaces the old Storage wrapper initializer.
     * Returns nil if storage creation fails.
     */
    static func createWithMigration(tpId: String, environment: String) -> TrackingplanShared.Storage? {
        guard let storage = try? TrackingplanShared.Storage.companion.create(tpId: tpId, environment: environment) else {
            return nil
        }
        migrateLegacyStorageIfNeeded(tpId: tpId, environment: environment, sharedStorage: storage)
        return storage
    }

    private static func migrateLegacyStorageIfNeeded(
        tpId: String,
        environment: String,
        sharedStorage: TrackingplanShared.Storage
    ) {
        guard let legacyDefaults = UserDefaults(suiteName: LEGACY_STORE_NAME) else { return }

        // Skip if legacy store has no data
        // Check both "tpId" (camelCase) and "tp_id" (snake_case) for backward compatibility
        // as different SDK versions may have used different key formats
        guard legacyDefaults.string(forKey: "tpId") != nil || legacyDefaults.string(forKey: "tp_id") != nil else {
            return
        }

        // Check if tpId/environment match (try both camelCase and snake_case key formats)
        var legacyTpId = legacyDefaults.string(forKey: "tpId")
        if legacyTpId == nil {
            legacyTpId = legacyDefaults.string(forKey: "tp_id")
        }
        let legacyEnvironment = legacyDefaults.string(forKey: "environment")

        let canMigrate = legacyTpId == tpId && legacyEnvironment == environment

        // Migrate only if tpId/environment match and new storage doesn't have data yet
        if canMigrate && sharedStorage.isFirstTimeExecution() {
            // Migrate only important keys: firstTimeExecutionTimestamp and lastDauEventSentTimestamp
            // Try camelCase keys first (original iOS format)
            if let firstTimeExecutedAt = legacyDefaults.object(forKey: "firstTimeExecutionTimestamp") as? NSNumber {
                sharedStorage.saveFirstTimeExecution(timestamp: firstTimeExecutedAt.int64Value)
            } else if legacyDefaults.object(forKey: "first_time_executed_at") != nil {
                // Try snake_case key (if migrated before)
                let value = legacyDefaults.integer(forKey: "first_time_executed_at")
                if value != 0 {
                    sharedStorage.saveFirstTimeExecution(timestamp: Int64(value))
                }
            }

            if let lastDauEventSentAt = legacyDefaults.object(forKey: "lastDauEventSentTimestamp") as? NSNumber {
                sharedStorage.saveLastDauEventSentTimestamp(timestamp: lastDauEventSentAt.int64Value)
            } else if legacyDefaults.object(forKey: "last_dau_event_sent_at") != nil {
                let value = legacyDefaults.integer(forKey: "last_dau_event_sent_at")
                if value != 0 {
                    sharedStorage.saveLastDauEventSentTimestamp(timestamp: Int64(value))
                }
            }
        }

        // Always clear legacy store
        clearLegacyStore()
    }

    private static func clearLegacyStore() {
        guard let legacyDefaults = UserDefaults(suiteName: LEGACY_STORE_NAME) else { return }
        legacyDefaults.removePersistentDomain(forName: LEGACY_STORE_NAME)
    }
}
