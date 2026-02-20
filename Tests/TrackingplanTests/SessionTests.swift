//
//  SessionTests.swift
//  TrackingplanTests
//
//  Port of Android SessionInstrumentedTest to iOS.
//

import XCTest
import TrackingplanShared
@testable import Trackingplan

final class SessionTests: BaseInstrumentedTest {

    // MARK: - Tests

    func test_given_SdkWasNeverExecutedBefore_when_SdkStarts_then_NewSessionStarted() throws {
        // Given - First time execution
        let instanceBeforeInit = TrackingplanManager.sharedInstance.mainInstance
        XCTAssertNil(instanceBeforeInit, "No instance should exist before init")

        // When
        logger.expectExactMessage(message: "Previous session expired or doesn't exist. Creating a new session...")
        logger.expectMessageStartsWith(prefix: "New session started")
        startTrackingplan()

        let instanceAfterInit = TrackingplanManager.sharedInstance.mainInstance
        let sessionAfterInit = instanceAfterInit?.currentSession

        // Then
        XCTAssertNotNil(instanceAfterInit, "Instance should exist after init")
        XCTAssertNotNil(sessionAfterInit, "Session should exist after init")
        XCTAssertFalse(sessionAfterInit?.sessionId.isEmpty ?? true, "Session ID should not be empty")
        XCTAssertTrue(sessionAfterInit?.trackingEnabled ?? false, "Tracking should be enabled")

        try logger.assertExpectationsMatch()
    }

    func test_given_SessionWithActivity5MinutesAgo_when_SdkStarts_then_KeepSession() throws {
        // Given
        startTrackingplan()
        let previousSessionId = TrackingplanManager.sharedInstance.mainInstance?.currentSession?.sessionId
        stopTrackingplan()
        fakeTime.advanceTime(ms: 5 * TrackingplanShared.TimeProviderCompanion.shared.MINUTE)

        // When
        logger.reset()
        logger.expectMessageStartsWith(prefix: "Session resumed")
        startTrackingplan()
        let currentSessionId = TrackingplanManager.sharedInstance.mainInstance?.currentSession?.sessionId

        // Then
        XCTAssertEqual(previousSessionId, currentSessionId, "Session should be the same")
        try logger.assertExpectationsMatch()
    }

    func test_given_SessionWithActivity30MinutesAgo_when_SdkStarts_then_CreateNewSession() throws {
        // Given
        startTrackingplan()
        let previousSessionId = TrackingplanManager.sharedInstance.mainInstance?.currentSession?.sessionId
        stopTrackingplan()
        fakeTime.advanceTime(ms: 30 * TrackingplanShared.TimeProviderCompanion.shared.MINUTE)

        // When
        logger.reset()
        logger.expectExactMessage(message: "Previous ingest config found and is still valid")
        logger.expectMessageStartsWith(prefix: "New session started")
        startTrackingplan()
        let currentSessionId = TrackingplanManager.sharedInstance.mainInstance?.currentSession?.sessionId
        stopTrackingplan()

        // Then
        XCTAssertNotEqual(previousSessionId, currentSessionId, "Session should be different")
        try logger.assertExpectationsMatch()
    }
}
