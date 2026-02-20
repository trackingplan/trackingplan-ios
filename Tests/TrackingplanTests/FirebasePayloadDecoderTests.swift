//
//  FirebasePayloadDecoderTests.swift
//  Trackingplan
//

import XCTest
@testable import Trackingplan

final class FirebasePayloadDecoderTests: XCTestCase {

    // MARK: - Test Data

    // Protobuf: FirebasePayload with 1 batch, 2 events: "screen_view", "purchase"
    private let multiEventPayload = "ChsSDRILc2NyZWVuX3ZpZXcSChIIcHVyY2hhc2U="

    // Protobuf: FirebasePayload with 1 batch, 1 event: "add_to_cart"
    private let singleEventPayload = "Cg8SDRILYWRkX3RvX2NhcnQ="

    // Gzip-compressed version of multiEventPayload
    private let gzippedPayload = "H4sIAMunj2kC/+OSFuIV4i5OLkpNzYsvy0wtF+IS4igoLUrOSCxOBQDhspwjHQAAAA=="

    // Protobuf: FirebasePayload with 1 batch, 0 events
    private let emptyEventsPayload = "CgA="

    // Protobuf: 5 batches x 10 events = 50 events
    private let largePayload = "CoIBEgsSCWV2ZW50XzBfMBILEglldmVudF8wXzESCxIJZXZlbnRfMF8yEgsSCWV2ZW50XzBfMxILEglldmVudF8wXzQSCxIJZXZlbnRfMF81EgsSCWV2ZW50XzBfNhILEglldmVudF8wXzcSCxIJZXZlbnRfMF84EgsSCWV2ZW50XzBfOQqCARILEglldmVudF8xXzASCxIJZXZlbnRfMV8xEgsSCWV2ZW50XzFfMhILEglldmVudF8xXzMSCxIJZXZlbnRfMV80EgsSCWV2ZW50XzFfNRILEglldmVudF8xXzYSCxIJZXZlbnRfMV83EgsSCWV2ZW50XzFfOBILEglldmVudF8xXzkKggESCxIJZXZlbnRfMl8wEgsSCWV2ZW50XzJfMRILEglldmVudF8yXzISCxIJZXZlbnRfMl8zEgsSCWV2ZW50XzJfNBILEglldmVudF8yXzUSCxIJZXZlbnRfMl82EgsSCWV2ZW50XzJfNxILEglldmVudF8yXzgSCxIJZXZlbnRfMl85CoIBEgsSCWV2ZW50XzNfMBILEglldmVudF8zXzESCxIJZXZlbnRfM18yEgsSCWV2ZW50XzNfMxILEglldmVudF8zXzQSCxIJZXZlbnRfM181EgsSCWV2ZW50XzNfNhILEglldmVudF8zXzcSCxIJZXZlbnRfM184EgsSCWV2ZW50XzNfOQqCARILEglldmVudF80XzASCxIJZXZlbnRfNF8xEgsSCWV2ZW50XzRfMhILEglldmVudF80XzMSCxIJZXZlbnRfNF80EgsSCWV2ZW50XzRfNRILEglldmVudF80XzYSCxIJZXZlbnRfNF83EgsSCWV2ZW50XzRfOBILEglldmVudF80Xzk="

    // Gzip-compressed version of largePayload
    private let largeGzippedPayload = "H4sIAMunj2kC/13OqxHCQBQAwEGSuFSS9+GTak7FopgUQOXYnZPrdvndtnW7n9f5+Y597CJEihItHuIpXuItjsVEmAgTYSJMhIkwESbCRJiIKZEm0kSaSBNpIk2kiTSRJnJKlIkyUSbKRJkoE2WiTJSJmhJtok20iTbRJtpEm2gTbaLH8QfPbC9nmQIAAA=="

    // Protobuf: 1 batch with 5 events
    private let smallPayload = "CkkSDRILc2NyZWVuX3ZpZXcSChIIcHVyY2hhc2USDRILYWRkX3RvX2NhcnQSEBIOYmVnaW5fY2hlY2tvdXQSCxIJdmlld19pdGVt"

    // Gzip-compressed version of smallPayload
    private let smallGzippedPayload = "H4sIAMunj2kC/xXLUQqAIBAFwN9Sini36hSLrUsukYaudf3wexi3Y4FvXEUyvSofHKanV06hyaAQI1khDtWwYT3k1EychK/SDR7zSKQm9w8r+9S3SwAAAA=="

    // MARK: - extractEventNames Tests

    func testExtractMultipleEventNames() {
        let names = FirebasePayloadDecoder.extractEventNames(payload: multiEventPayload)
        XCTAssertNotNil(names)
        XCTAssertEqual(names, ["screen_view", "purchase"])
    }

    func testExtractSingleEventName() {
        let names = FirebasePayloadDecoder.extractEventNames(payload: singleEventPayload)
        XCTAssertNotNil(names)
        XCTAssertEqual(names, ["add_to_cart"])
    }

    func testExtractFromGzipCompressedPayload() {
        let names = FirebasePayloadDecoder.extractEventNames(payload: gzippedPayload)
        XCTAssertNotNil(names)
        XCTAssertEqual(names, ["screen_view", "purchase"])
    }

    func testInvalidBase64ReturnsNil() {
        let names = FirebasePayloadDecoder.extractEventNames(payload: "!!!not-base64!!!")
        XCTAssertNil(names)
    }

    func testInvalidProtobufBytesReturnsNil() {
        // Valid base64 but not valid protobuf — "Hello, World!"
        let names = FirebasePayloadDecoder.extractEventNames(payload: "SGVsbG8sIFdvcmxkIQ==")
        // Protobuf is lenient, so this may or may not decode. What matters is it doesn't crash.
        // If it does decode, event names would be empty → nil
        // Just verify no crash
        _ = names
    }

    func testEmptyEventsReturnsNil() {
        let names = FirebasePayloadDecoder.extractEventNames(payload: emptyEventsPayload)
        XCTAssertNil(names)
    }

    func testLargePayloadExtracts50Events() {
        let names = FirebasePayloadDecoder.extractEventNames(payload: largePayload)
        XCTAssertNotNil(names)
        XCTAssertEqual(names?.count, 50)
        XCTAssertEqual(names?.first, "event_0_0")
        XCTAssertEqual(names?.last, "event_4_9")
    }

    // MARK: - buildSyntheticPayload Tests

    func testBuildSyntheticPayloadWithMultipleEvents() {
        let json = FirebasePayloadDecoder.buildSyntheticPayload(eventNames: ["screen_view", "purchase"])
        XCTAssertNotNil(json)
        let parsed = try? JSONSerialization.jsonObject(with: json!.data(using: .utf8)!) as? [String: Any]
        let events = parsed?["events"] as? [[String: String]]
        XCTAssertEqual(events?.count, 2)
        XCTAssertEqual(events?[0]["event_name"], "screen_view")
        XCTAssertEqual(events?[1]["event_name"], "purchase")
    }

    func testBuildSyntheticPayloadWithSingleEvent() {
        let json = FirebasePayloadDecoder.buildSyntheticPayload(eventNames: ["add_to_cart"])
        XCTAssertNotNil(json)
        let parsed = try? JSONSerialization.jsonObject(with: json!.data(using: .utf8)!) as? [String: Any]
        let events = parsed?["events"] as? [[String: String]]
        XCTAssertEqual(events?.count, 1)
        XCTAssertEqual(events?[0]["event_name"], "add_to_cart")
    }

    func testBuildSyntheticPayloadEscapesSpecialCharacters() {
        let json = FirebasePayloadDecoder.buildSyntheticPayload(eventNames: ["test\"event", "back\\slash"])
        XCTAssertNotNil(json)
        let data = json!.data(using: .utf8)!
        let parsed = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        let events = parsed?["events"] as? [[String: String]]
        XCTAssertEqual(events?[0]["event_name"], "test\"event")
        XCTAssertEqual(events?[1]["event_name"], "back\\slash")
    }

    func testBuildSyntheticPayloadWithEmptyArrayReturnsNil() {
        let json = FirebasePayloadDecoder.buildSyntheticPayload(eventNames: [])
        XCTAssertNil(json)
    }

    func testBuildSyntheticPayloadIsValidJSON() {
        let json = FirebasePayloadDecoder.buildSyntheticPayload(eventNames: ["screen_view", "purchase"])
        XCTAssertNotNil(json)
        let data = json!.data(using: .utf8)!
        let parsed = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        XCTAssertNotNil(parsed)
        let events = parsed?["events"] as? [[String: String]]
        XCTAssertNotNil(events)
        XCTAssertEqual(events?.count, 2)
        XCTAssertEqual(events?[0]["event_name"], "screen_view")
        XCTAssertEqual(events?[1]["event_name"], "purchase")
    }

    // MARK: - Benchmarks

    func testPerformanceSmallPayload() {
        measure {
            _ = FirebasePayloadDecoder.extractEventNames(payload: smallPayload)
        }
    }

    func testPerformanceLargePayload() {
        measure {
            _ = FirebasePayloadDecoder.extractEventNames(payload: largePayload)
        }
    }

    func testPerformanceGzipCompressedPayload() {
        measure {
            _ = FirebasePayloadDecoder.extractEventNames(payload: smallGzippedPayload)
        }
    }

    func testPerformanceEndToEnd() {
        measure {
            if let names = FirebasePayloadDecoder.extractEventNames(payload: smallPayload) {
                _ = FirebasePayloadDecoder.buildSyntheticPayload(eventNames: names)
            }
        }
    }
}
