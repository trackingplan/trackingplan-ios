//
//  BaseInstrumentedTest.swift
//  TrackingplanTests
//
//  Copyright (c) 2026 Trackingplan
//
//  Base test class with shared setup, teardown, and helper methods.
//

import XCTest
import TrackingplanShared
@testable import Trackingplan

class BaseInstrumentedTest: XCTestCase {

    static let testTpId = "TP000000"
    static let testEnvironment = "PRODUCTION"

    var logger: TrackingplanShared.TestLogger!
    var fakeTime: TrackingplanShared.TestTimeProvider!

    override func setUp() {
        super.setUp()

        logger = TrackingplanShared.TestLogger(maxSize: 20)
        TrackingplanManager.logger.addLogger(logger)
        TrackingplanManager.logger.enableLogging()

        fakeTime = TrackingplanShared.TestTimeProvider()
        TrackingplanShared.ServiceLocator.shared.setTimeProvider(provider: fakeTime)

        clearStorage()
    }

    override func tearDown() {
        stopTrackingplan()
        TrackingplanManager.logger.removeLogger(logger)
        TrackingplanShared.ServiceLocator.shared.reset()
        super.tearDown()
    }

    // MARK: - Helpers

    func startTrackingplan(tpId: String = testTpId, environment: String = testEnvironment, fakeSampling: Bool = true, dryRun: Bool = true) {
        // Pre-populate cache before initialize to avoid network downloads in tests
        if fakeSampling {
            let storage = try! TrackingplanShared.Storage.companion.create(tpId: tpId, environment: environment)
            try? storage.ingestConfigCache.save(jsonContent: "{\"sample_rate\": 1}")
            // Also set tracking enabled since sample_rate: 1 means tracking should be enabled
            storage.saveTrackingEnabled(enabled: true)
        }

        let instance = Trackingplan.initialize(
            tpId: tpId,
            environment: environment,
            tags: ["tag1": "value1"],
            debug: true,
            dryRun: dryRun,
            regressionTesting: false
        )

        XCTAssertNotNil(instance, "Trackingplan should initialize successfully")

        // Wait for async initialization to complete on the serial queue
        instance?.serialQueue.sync {}
    }

    func stopTrackingplan() {
        if let instance = TrackingplanManager.sharedInstance.mainInstance {
            instance.stop()
            // Wait for async shutdown to complete on the serial queue
            instance.serialQueue.sync {}
        }
        TrackingplanManager.sharedInstance.mainInstance = nil
    }

    func clearStorage(tpId: String = testTpId, environment: String = testEnvironment) {
        // storage.clear() also clears the ingestConfigCache
        let storage = try! TrackingplanShared.Storage.companion.create(tpId: tpId, environment: environment)
        storage.clear()

        // Clear storage for other common test configurations (also clears their caches)
        let storage2 = try! TrackingplanShared.Storage.companion.create(tpId: "TP873633", environment: "PRODUCTION")
        storage2.clear()
        let storage3 = try! TrackingplanShared.Storage.companion.create(tpId: "TP873633", environment: "preproduction")
        storage3.clear()
    }

    func createFakeRequest() -> URLRequest {
        let url = URL(string: "https://api.amplitude.com/batch")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }

    func processFakeRequestAndFlush() {
        guard let instance = TrackingplanManager.sharedInstance.mainInstance else {
            XCTFail("Trackingplan not initialized")
            return
        }

        instance.processRequest(createFakeRequest())
        instance.flushQueue()
    }
}
