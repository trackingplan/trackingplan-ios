    import XCTest
    @testable import Trackingplan

    final class TrackingplanTests: XCTestCase {
        
        override func tearDown() {
            super.tearDown()
            // Clean up any initialized instances
            if let instance = TrackingplanManager.sharedInstance.mainInstance {
                instance.stop()
            }
            TrackingplanManager.sharedInstance.mainInstance = nil
        }
        
        func testUpdateTagsAfterInitialization() {
            // Initialize Trackingplan with initial tags
            let initialTags = ["initial_key": "initial_value", "env": "test"]
            let instance = Trackingplan.initialize(
                tpId: "test-tp-id",
                environment: "TEST",
                tags: initialTags,
                debug: true
            )
            
            XCTAssertNotNil(instance, "Trackingplan should initialize successfully")
            
            // Update tags with new values
            let newTags = ["new_key": "new_value", "env": "updated_test"]
            Trackingplan.updateTags(newTags)
            
            // Give time for async operation to complete
            let expectation = self.expectation(description: "Tags update")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                expectation.fulfill()
            }
            waitForExpectations(timeout: 1.0, handler: nil)
            
            // Verify tags were updated (merged)
            XCTAssertEqual(instance?.config.tags["initial_key"], "initial_value", "Original tag should remain")
            XCTAssertEqual(instance?.config.tags["new_key"], "new_value", "New tag should be added")
            XCTAssertEqual(instance?.config.tags["env"], "updated_test", "Existing tag should be updated")
        }
        
        func testUpdateTagsWithoutInitialization() {
            // Ensure no instance exists
            TrackingplanManager.sharedInstance.mainInstance = nil
            
            // Attempt to update tags without initialization
            let newTags = ["key": "value"]
            Trackingplan.updateTags(newTags)
            
            // No crash should occur, method should handle gracefully
            XCTAssertNil(TrackingplanManager.sharedInstance.mainInstance, "No instance should exist")
        }
        
        func testUpdateTagsEmptyDictionary() {
            // Initialize Trackingplan
            let initialTags = ["key1": "value1"]
            let instance = Trackingplan.initialize(
                tpId: "test-tp-id",
                environment: "TEST",
                tags: initialTags,
                debug: true
            )
            
            XCTAssertNotNil(instance, "Trackingplan should initialize successfully")
            
            // Update with empty dictionary
            Trackingplan.updateTags([:])
            
            // Give time for async operation to complete
            let expectation = self.expectation(description: "Empty tags update")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                expectation.fulfill()
            }
            waitForExpectations(timeout: 1.0, handler: nil)
            
            // Original tags should remain unchanged
            XCTAssertEqual(instance?.config.tags["key1"], "value1", "Original tag should remain")
        }
        
        func testUpdateTagsMultipleTimes() {
            // Initialize Trackingplan
            let instance = Trackingplan.initialize(
                tpId: "test-tp-id",
                environment: "TEST",
                tags: ["initial": "value"],
                debug: true
            )
            
            XCTAssertNotNil(instance, "Trackingplan should initialize successfully")
            
            // Update tags multiple times
            Trackingplan.updateTags(["tag1": "value1"])
            Trackingplan.updateTags(["tag2": "value2"])
            Trackingplan.updateTags(["tag1": "updated_value1", "tag3": "value3"])
            
            // Give time for async operations to complete
            let expectation = self.expectation(description: "Multiple tags updates")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                expectation.fulfill()
            }
            waitForExpectations(timeout: 2.0, handler: nil)
            
            // Verify final state
            XCTAssertEqual(instance?.config.tags["initial"], "value", "Initial tag should remain")
            XCTAssertEqual(instance?.config.tags["tag1"], "updated_value1", "Tag1 should be updated")
            XCTAssertEqual(instance?.config.tags["tag2"], "value2", "Tag2 should exist")
            XCTAssertEqual(instance?.config.tags["tag3"], "value3", "Tag3 should exist")
        }
    }
