//
//  FirebaseInstrumentedTests.swift
//  TrackingplanTests
//
//  End-to-end tests for Firebase Analytics (googleanalyticsfirebase) request processing.
//  Verifies the full iOS pipeline: URLRequest with gzipped protobuf → FirebasePayloadDecoder
//  → synthetic JSON → adaptive sampling → batch with correct sampling_rate.
//

import XCTest
import TrackingplanShared
@testable import Trackingplan

final class FirebaseInstrumentedTests: BaseInstrumentedTest {

    // MARK: - Tests

    func test_given_AdaptiveSamplingForFirebase_when_PurchaseEventProcessed_then_AdaptiveSamplingApplied() throws {
        // Given - Pre-populate cache with adaptive sampling config for Firebase.
        // Using event sample_rate=1 to ensure deterministic rescue probability (1.0)
        // for unsampled sessions, matching the pattern used by the Amplitude test.
        let storage = try! TrackingplanShared.Storage.companion.create(tpId: Self.testTpId, environment: Self.testEnvironment)
        let configJson = """
            {
                "sample_rate": 100,
                "options": {
                    "useAdaptiveSampling": true,
                    "adaptiveSamplingPatterns": ["{\\"provider\\":\\"googleanalyticsfirebase\\",\\"match\\":{\\"event_name\\":\\"purchase\\"},\\"sample_rate\\":1}"]
                }
            }
            """
        try? storage.ingestConfigCache.save(jsonContent: configJson)

        startTrackingplan(fakeSampling: false)

        guard let instance = TrackingplanManager.sharedInstance.mainInstance else {
            XCTFail("Trackingplan instance should exist")
            return
        }

        // When - Process Firebase request with a "purchase" event (gzipped protobuf body)
        logger.reset()
        logger.expectExactMessage(message: "Processing request POST https://app-measurement.com/a")
        logger.expectMessageStartingWithAndContaining(prefix: "Batch:", contains: [
            "\"endpoint\":\"https:\\/\\/app-measurement.com\\/a\"",
            "\"sampling_rate\":1",
            "\"sampling_mode\":\"ADAPTIVE\\/EVENT_DICE\\/EVENT_MATCHED\""
        ])

        instance.processRequest(createFakeFirebaseRequest(eventNames: ["purchase"]))
        instance.flushQueue()

        waitForProcessing()

        // Then
        try logger.assertExpectationsMatch()

        XCTAssertFalse(
            logger.containsExactMessage(msg: "Unknown destination. Ignoring request"),
            "Firebase request should be matched to googleanalyticsfirebase provider"
        )
    }

    // MARK: - Helpers

    private func createFakeFirebaseRequest(eventNames: [String]) -> URLRequest {
        var events = [FirebaseEvent]()
        for name in eventNames {
            var event = FirebaseEvent()
            event.eventName = name
            events.append(event)
        }

        var batch = FirebaseBatch()
        batch.events = events
        // Setting appVersion (proto field 16) produces tag byte 0x82 in the
        // serialized protobuf. This byte is an invalid UTF-8 continuation byte,
        // which forces getStringFromHttpBody() to base64-encode the gzipped data
        // instead of returning it as a UTF-8 string — matching real-world behavior
        // where Firebase payloads contain binary metadata fields.
        batch.appVersion = "1.0"

        var payload = FirebasePayload()
        payload.data = [batch]

        let protobufData = try! payload.serializedData()
        let gzippedData = try! protobufData.gzipped()

        let url = URL(string: "https://app-measurement.com/a")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = gzippedData
        return request
    }

    private func waitForProcessing() {
        let expectation = self.expectation(description: "Wait for processing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
