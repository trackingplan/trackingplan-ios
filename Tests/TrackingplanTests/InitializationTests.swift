//
//  InitializationTests.swift
//  TrackingplanTests
//
//  Port of Android InitializationInstrumentedTest to iOS.
//

import XCTest
@testable import Trackingplan

final class InitializationTests: BaseInstrumentedTest {

    // MARK: - Tests

    func test_given_SdkWasNeverExecutedBefore_when_SdkStart_then_SdkStarts() throws {
        // Given - Clear state (done in setUp)

        // When - Cache is pre-populated by startTrackingplan helper
        logger.expectExactMessage(message: "Previous ingest config found and is still valid")
        logger.expectMessageStartsWith(prefix: "New session started")
        startTrackingplan()

        // Then
        try logger.assertExpectationsMatch()

        let instance = TrackingplanManager.sharedInstance.mainInstance
        XCTAssertNotNil(instance, "Trackingplan should be initialized")
    }

    func test_given_SdkAlreadyStarted_when_CallingSdkStartAgain_then_StartIgnored() throws {
        // Given
        startTrackingplan()

        // When
        logger.reset()
        logger.expectExactMessage(message: "Trackingplan already initialized. Action ignored")
        startTrackingplan()

        // Then
        try logger.assertExpectationsMatch()
    }
}
