//
//  TrackingplanIngestConfigParserTests.swift
//  TrackingplanTests
//

import XCTest
import TrackingplanShared
@testable import Trackingplan

final class TrackingplanIngestConfigParserTests: XCTestCase {

    func testParseMalformedJsonThrows() {
        let malformedJson = "{ invalid json }"

        do {
            _ = try TrackingplanIngestConfigParser.shared.parse(jsonString: malformedJson)
            XCTFail("Expected parse to throw an error for malformed JSON")
        } catch {
            // Expected - parsing should throw an error that Swift can catch
            XCTAssertNotNil(error)
        }
    }

    func testParseValidJson() throws {
        let validJson = """
        {
            "sample_rate": 100
        }
        """

        let config = try TrackingplanIngestConfigParser.shared.parse(jsonString: validJson)
        XCTAssertNotNil(config)
        XCTAssertEqual(config.sampleRate, 100)
    }
}
