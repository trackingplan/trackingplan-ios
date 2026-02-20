//
//  PreQueueTests.swift
//  TrackingplanTests
//
//  Tests for preQueue and request processing functionality.
//
//  Note: Direct testing of the preQueue mechanism requires precise timing control
//  between request interception and session initialization. These tests verify
//  the observable behavior of request processing similar to Android's approach.
//

import XCTest
import TrackingplanShared
@testable import Trackingplan

final class PreQueueTests: BaseInstrumentedTest {

    // MARK: - Tests

    func test_given_SessionStarted_when_RequestProcessed_then_RequestQueued() throws {
        // Given - Start trackingplan with session (use dryRun to capture batch without sending)
        let storage = try! TrackingplanShared.Storage.companion.create(tpId: Self.testTpId, environment: Self.testEnvironment)
        try? storage.ingestConfigCache.save(jsonContent: "{\"sample_rate\": 1}")
        storage.saveTrackingEnabled(enabled: true)

        Trackingplan.initialize(
            tpId: Self.testTpId,
            environment: Self.testEnvironment,
            tags: ["tag1": "value1"],
            debug: true,
            dryRun: true
        )

        // Wait for async initialization
        waitForProcessing()

        let instance = TrackingplanManager.sharedInstance.mainInstance
        XCTAssertNotNil(instance, "Instance should exist")

        // Verify session is active
        XCTAssertNotNil(instance?.currentSession, "Session should exist")
        XCTAssertFalse(instance?.currentSession?.sessionId.isEmpty ?? true, "Session ID should not be empty")
        XCTAssertTrue(instance?.currentSession?.trackingEnabled ?? false, "Tracking should be enabled")

        // When - Process a request
        logger.reset()
        // The SDK logs "Processing request..." for amplitude requests
        logger.expectMessageStartsWith(prefix: "Processing request POST https://api.amplitude.com/batch")
        // In dryRun mode, the batch is processed but not sent
        logger.expectExactMessage(message: "Dry run mode enabled. No tracks sent")

        instance?.processRequest(createFakeAmplitudeRequest())
        instance?.flushQueue()

        // Wait for async operations
        waitForProcessing()

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_TrackingplanInitButNoSession_when_RequestProcessed_then_RequestPreQueued() throws {
        // Given - Create instance without starting session
        let storage = try! TrackingplanShared.Storage.companion.create(tpId: Self.testTpId, environment: Self.testEnvironment)
        try? storage.ingestConfigCache.save(jsonContent: "{\"sample_rate\": 1}")
        storage.saveTrackingEnabled(enabled: true)

        let config = TrackingplanConfig(
            tp_id: Self.testTpId,
            environment: Self.testEnvironment,
            tags: ["tag1": "value1"],
            debug: true,
            dryRun: true
        )!

        guard let instance = TrackingplanInstance(config: config) else {
            XCTFail("Failed to create instance")
            return
        }

        // Register instance so tearDown can clean it up
        TrackingplanManager.sharedInstance.mainInstance = instance

        // Verify session is NOT ready yet
        XCTAssertNil(instance.currentSession, "Session should not exist yet")

        // When - Process a request before session starts (currentSession is nil)
        logger.reset()
        logger.expectMessageStartsWith(prefix: "Request pre-queued (session not ready)")  // amplitude request
        logger.expectMessageStartsWith(prefix: "Request pre-queued (session not ready)")  // new_session event
        logger.expectMessageStartsWith(prefix: "Request pre-queued (session not ready)")  // new_dau event
        logger.expectMessageStartsWith(prefix: "Request pre-queued (session not ready)")  // new_user event
        logger.expectExactMessage(message: "Processing 4 pre-queued requests...")
        logger.expectExactMessage(message: "Pre-queue processed")
        logger.expectExactMessage(message: "Dry run mode enabled. No tracks sent")

        // Process request synchronously - goes to preQueue since currentSession is nil
        instance.processRequest(createFakeAmplitudeRequest())

        // Now start the session (this will process preQueue)
        instance.start()

        // Wait for async operations
        waitForProcessing()

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_TrackingDisabled_when_RequestProcessed_then_RequestDropped() throws {
        // Given - Pre-populate cache with tracking disabled
        let storage = try! TrackingplanShared.Storage.companion.create(tpId: Self.testTpId, environment: Self.testEnvironment)
        try? storage.ingestConfigCache.save(jsonContent: "{\"sample_rate\": 0}")
        storage.saveTrackingEnabled(enabled: false)

        // Use fakeSampling: false to avoid overwriting our tracking disabled cache
        startTrackingplan(fakeSampling: false)
        let instance = TrackingplanManager.sharedInstance.mainInstance

        // Verify tracking is disabled
        XCTAssertFalse(instance?.currentSession?.trackingEnabled ?? true, "Tracking should be disabled")

        // When - Process a request
        logger.reset()
        logger.expectMessageStartsWith(prefix: "Request dropped (reason: tracking-disabled)")

        instance?.processRequest(createFakeAmplitudeRequest())

        // Wait for async operations
        waitForProcessing()

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_CustomDomainConfigured_when_RequestForCustomDomain_then_RequestMatched() throws {
        // Given - Pre-populate cache
        let storage = try! TrackingplanShared.Storage.companion.create(tpId: Self.testTpId, environment: Self.testEnvironment)
        try? storage.ingestConfigCache.save(jsonContent: "{\"sample_rate\": 1}")
        storage.saveTrackingEnabled(enabled: true)

        // Start with custom domains
        Trackingplan.initialize(
            tpId: Self.testTpId,
            environment: Self.testEnvironment,
            customDomains: ["analytics.mycompany.com": "custom_provider"],
            debug: true,
            dryRun: true
        )

        // Wait for async initialization
        waitForProcessing()

        let instance = TrackingplanManager.sharedInstance.mainInstance

        // Verify session started
        XCTAssertNotNil(instance?.currentSession, "Session should exist")
        XCTAssertFalse(instance?.currentSession?.sessionId.isEmpty ?? true, "Session ID should not be empty")

        // When - Process request for custom domain
        logger.reset()
        logger.expectExactMessage(message: "Processing request POST https://analytics.mycompany.com/track")
        logger.expectMessageStartingWithAndContaining(prefix: "Batch:", contains: ["\"endpoint\":\"https:\\/\\/analytics.mycompany.com\\/track\""])

        instance?.processRequest(createRequestForUrl("https://analytics.mycompany.com/track"))
        instance?.flushQueue()

        // Wait for async operations
        waitForProcessing()

        // Then
        try logger.assertExpectationsMatch()

        // Also verify request was NOT ignored as unknown destination
        XCTAssertFalse(
            logger.containsExactMessage(msg: "Unknown destination. Ignoring request"),
            "Request should be matched to custom provider, not ignored"
        )
    }

    func test_given_UnknownDomain_when_RequestProcessed_then_RequestIgnored() throws {
        // Given - Start trackingplan without custom domains
        startTrackingplan()
        let instance = TrackingplanManager.sharedInstance.mainInstance

        // When - Process request for unknown domain
        logger.reset()
        logger.expectExactMessage(message: "Processing request POST https://unknown-analytics.example.com/track")
        // The SDK logs "Unknown destination. Ignoring request..." for unmatched domains
        logger.expectMessageStartsWith(prefix: "Unknown destination. Ignoring request")

        instance?.processRequest(createRequestForUrl("https://unknown-analytics.example.com/track"))

        // Wait for async operations
        waitForProcessing()

        // Then
        try logger.assertExpectationsMatch()
    }

    func test_given_AdaptiveSamplingConfigured_when_RequestProcessed_then_SamplingEvaluated() throws {
        // Given - Pre-populate cache with adaptive sampling config
        let storage = try! TrackingplanShared.Storage.companion.create(tpId: Self.testTpId, environment: Self.testEnvironment)
        let configJson = """
            {
                "sample_rate": 100,
                "options": {
                    "useAdaptiveSampling": true,
                    "adaptiveSamplingPatterns": ["{\\"provider\\":\\"amplitude\\",\\"sample_rate\\":1}"]
                }
            }
            """
        try? storage.ingestConfigCache.save(jsonContent: configJson)

        startTrackingplan(fakeSampling: false)
        let instance = TrackingplanManager.sharedInstance.mainInstance

        // When - Process amplitude request (should be rescued by adaptive sampling)
        logger.reset()
        logger.expectExactMessage(message: "Processing request POST https://api.amplitude.com/batch")
        logger.expectMessageStartingWithAndContaining(prefix: "Batch:", contains: ["\"endpoint\":\"https:\\/\\/api.amplitude.com\\/batch\"", "\"sampling_rate\":1", "\"sampling_mode\":\"ADAPTIVE\\/EVENT_DICE\\/EVENT_MATCHED\""])

        instance?.processRequest(createFakeAmplitudeRequest())
        instance?.flushQueue()

        // Wait for async operations
        waitForProcessing()

        // Then
        try logger.assertExpectationsMatch()

        // Also verify request was not ignored as unknown destination
        XCTAssertFalse(
            logger.containsExactMessage(msg: "Unknown destination. Ignoring request"),
            "Request should not be ignored as unknown destination"
        )
    }

    // MARK: - Helpers

    private func createFakeAmplitudeRequest() -> URLRequest {
        let url = URL(string: "https://api.amplitude.com/batch")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }

    private func createRequestForUrl(_ urlString: String) -> URLRequest {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }

    private func waitForProcessing() {
        // Wait for all async operations to complete on the serial queue
        TrackingplanManager.sharedInstance.mainInstance?.serialQueue.sync {}
    }
}
