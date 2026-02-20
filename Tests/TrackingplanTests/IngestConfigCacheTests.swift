//
//  IngestConfigCacheTests.swift
//  TrackingplanTests
//
//  Port of Android IngestConfigCacheInstrumentedTest to iOS.
//

import XCTest
import TrackingplanShared
@testable import Trackingplan

final class IngestConfigCacheTests: BaseInstrumentedTest {

    // MARK: - Tests

    func test_given_EmptyIngestConfigCache_when_SdkStarts_then_IngestConfigIsDownloaded() throws {
        // When
        logger.expectExactMessage(message: "Ingest config expired or not found. Downloading...")
        logger.expectExactMessage(message: "Ingest config downloaded and saved")
        startTrackingplan(tpId: BaseInstrumentedTest.testTpId, environment: BaseInstrumentedTest.testEnvironment, fakeSampling: false)

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_CachedIngestConfig_when_SdkStarts_then_IngestConfigIsFound() throws {
        // Given - Cache is pre-populated by startTrackingplan helper to avoid race condition

        // When
        logger.expectExactMessage(message: "Previous ingest config found and is still valid")
        startTrackingplan()

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_CachedIngestConfig_when_SdkRestarts_then_CacheIsUsed() throws {
        // Given - first download caches the config
        logger.expectExactMessage(message: "Ingest config expired or not found. Downloading...")
        logger.expectExactMessage(message: "Ingest config downloaded and saved")
        logger.expectMessageStartsWith(prefix: "Sampling rate:")
        startTrackingplan(tpId: "TP873633", environment: "PRODUCTION", fakeSampling: false)
        stopTrackingplan()

        // When - second start should use cached config
        logger.expectExactMessage(message: "Previous ingest config found and is still valid")
        logger.expectMessageStartsWith(prefix: "Sampling rate:")
        startTrackingplan(tpId: "TP873633", environment: "PRODUCTION", fakeSampling: false)

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_PreviousIngestConfig_when_SdkStartsBefore24h_then_IngestConfigIsKept() throws {
        // Given
        startTrackingplan()
        stopTrackingplan()
        fakeTime.advanceTime(ms: 23 * TrackingplanShared.TimeProviderCompanion.shared.HOUR)

        // When
        logger.reset()
        logger.expectExactMessage(message: "Previous ingest config found and is still valid")
        startTrackingplan()

        // Then
        try logger.assertExpectationsMatch()
        XCTAssertFalse(logger.containsExactMessage(msg: "Ingest config expired or not found. Downloading..."))
    }

    func test_given_PreviousIngestConfig_when_SdkStartsAfter24h_then_IngestConfigIsDownloaded() throws {
        // Given
        startTrackingplan()
        stopTrackingplan()
        fakeTime.advanceTime(ms: 24 * TrackingplanShared.TimeProviderCompanion.shared.HOUR)

        // When
        logger.reset()
        logger.expectExactMessage(message: "Ingest config expired or not found. Downloading...")
        logger.expectExactMessage(message: "Ingest config downloaded and saved")
        startTrackingplan(tpId: BaseInstrumentedTest.testTpId, environment: BaseInstrumentedTest.testEnvironment, fakeSampling: false)

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_ActiveSession_when_SdkRestartsWithinSessionTimeout_then_SessionResumed() throws {
        // First start - new session is created
        logger.expectExactMessage(message: "Previous ingest config found and is still valid")
        logger.expectMessageStartsWith(prefix: "New session started")
        logger.expectExactMessage(message: "Queued Trackingplan new_session event")
        logger.expectExactMessage(message: "Queued Trackingplan new_dau event")
        logger.expectExactMessage(message: "Queued Trackingplan new_user event")
        // Second start - session is resumed (within 30 minute timeout)
        // Note: no new_dau event since only 15 min elapsed, not 24h
        logger.expectExactMessage(message: "Previous ingest config found and is still valid")
        logger.expectMessageStartsWith(prefix: "Session resumed")

        // First start
        startTrackingplan()
        fakeTime.advanceTime(ms: 10 * TrackingplanShared.TimeProviderCompanion.shared.MINUTE)
        stopTrackingplan()

        // Second start - resume session after 5 minutes (total 15 min, within 30 min timeout)
        fakeTime.advanceTime(ms: 5 * TrackingplanShared.TimeProviderCompanion.shared.MINUTE)
        startTrackingplan()

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_SessionSpanning2Days_when_SdkStartsEveryDay_then_IngestConfigIsDownloaded() throws {
        // First day: start session, download config, queue events
        logger.expectExactMessage(message: "Ingest config expired or not found. Downloading...")
        logger.expectExactMessage(message: "Ingest config downloaded and saved")
        logger.expectMessageStartsWith(prefix: "New session started")
        logger.expectExactMessage(message: "Queued Trackingplan new_session event")
        logger.expectExactMessage(message: "Queued Trackingplan new_dau event")
        logger.expectExactMessage(message: "Queued Trackingplan new_user event")

        // Second day: config re-downloaded, session RESUMED (not new), new DAU event
        logger.expectExactMessage(message: "Ingest config expired or not found. Downloading...")
        logger.expectExactMessage(message: "Ingest config downloaded and saved")
        logger.expectMessageStartsWith(prefix: "Session resumed")
        logger.expectExactMessage(message: "Queued Trackingplan new_dau event")

        // First day: start tracking (no cache pre-population = real download)
        startTrackingplan(tpId: BaseInstrumentedTest.testTpId, environment: BaseInstrumentedTest.testEnvironment, fakeSampling: false)

        // Advance 28 hours while session is running (session stays active)
        fakeTime.advanceTime(ms: 28 * TrackingplanShared.TimeProviderCompanion.shared.HOUR)
        stopTrackingplan() // Session duration is 28h, still active (timeout is 30min after stop)

        // Second day: resume after 5 minutes since stop (within 30min session timeout)
        fakeTime.advanceTime(ms: 5 * TrackingplanShared.TimeProviderCompanion.shared.MINUTE)
        startTrackingplan(tpId: BaseInstrumentedTest.testTpId, environment: BaseInstrumentedTest.testEnvironment, fakeSampling: false)

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_FakeSamplingDisabled_when_SdkStartsWithProvisionedTpId_then_IngestConfigIsDownloaded() throws {
        // When
        logger.expectExactMessage(message: "Ingest config expired or not found. Downloading...")
        logger.expectExactMessage(message: "Ingest config downloaded and saved")
        logger.expectMessageStartsWith(prefix: "Sampling rate: 15")
        startTrackingplan(tpId: "TP873633", environment: "PRODUCTION", fakeSampling: false)

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_FakeSamplingDisabled_when_SdkStartsWithNotProvisionedTpId_then_IngestConfigIsDownloaded() throws {
        // Test workaround for response 404 when downloading ingest config

        // When
        logger.expectExactMessage(message: "Ingest config expired or not found. Downloading...")
        logger.expectExactMessage(message: "Ingest config downloaded and saved")
        logger.expectMessageStartsWith(prefix: "Sampling rate: 1")
        startTrackingplan(tpId: "TP000000", environment: "PRODUCTION", fakeSampling: false)

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_FakeSamplingDisabled_when_SdkStartsWithEnv_then_IngestConfigFromThatEnvIsDownloaded() throws {
        // When
        logger.expectExactMessage(message: "Ingest config expired or not found. Downloading...")
        logger.expectExactMessage(message: "Ingest config downloaded and saved")
        logger.expectMessageStartsWith(prefix: "Sampling rate: 1")
        startTrackingplan(tpId: "TP873633", environment: "preproduction", fakeSampling: false)

        // Then
        try logger.assertExpectationsMatch()
    }
}
