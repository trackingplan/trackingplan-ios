//
//  TagsInstrumentedTests.swift
//  TrackingplanTests
//
//  Copyright (c) 2026 Trackingplan
//
//  Instrumented test for updateTags functionality.
//  Port of Android's TagsInstrumentedTest.java
//

import XCTest
@testable import Trackingplan

final class TagsInstrumentedTests: BaseInstrumentedTest {

    func test_given_TrackingplanInitialized_when_UpdateTags_then_TagsAreUpdated() throws {
        // Given
        startTrackingplan()

        // When
        logger.expectMessageStartsWith(prefix: "Tags updated:")
        logger.expectMessageStartingWithAndContaining(prefix: "Batch:", contains: ["\"tag2\"", "\"value2\"", "\"tag3\"", "\"value3\""])

        Trackingplan.updateTags(["tag2": "value2", "tag3": "value3"])
        processFakeRequestAndFlush()

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_TrackingplanNotInitialized_when_UpdateTags_then_ErrorLogged() throws {
        // Given - Trackingplan not initialized (no startTrackingplan() called)
        TrackingplanManager.sharedInstance.mainInstance = nil

        // When
        logger.expectExactMessage(message: "Cannot update tags. Trackingplan was not initialized")
        Trackingplan.updateTags(["tag2": "value2"])

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_ExistingTags_when_UpdateTagsWithOverlappingKeys_then_TagsAreMerged() throws {
        // Given
        startTrackingplan() // starts with tag1=value1

        // When
        logger.expectMessageStartsWith(prefix: "Tags updated:")
        logger.expectMessageStartingWithAndContaining(prefix: "Batch:", contains: ["\"tag1\"", "\"newvalue1\"", "\"tag2\"", "\"value2\""])

        Trackingplan.updateTags(["tag1": "newvalue1", "tag2": "value2"])
        processFakeRequestAndFlush()

        // Then
        try logger.assertExpectationsMatch()
    }
}
