//
//  FirebasePayloadDecoder.swift
//  Trackingplan
//

import Foundation
import SwiftProtobuf

enum FirebasePayloadDecoder {

    private struct SyntheticEvent: Encodable { let event_name: String }
    private struct SyntheticPayload: Encodable { let events: [SyntheticEvent] }

    /// Extracts event names from a base64-encoded, optionally gzip-compressed Firebase protobuf payload.
    /// Gzip is auto-detected via magic bytes. Returns `nil` on any failure (safe fallback to plan-level sampling).
    static func extractEventNames(payload: String) -> [String]? {
        guard let data = Data(base64Encoded: payload) else { return nil }

        let decompressed: Data
        if data.isGzipped {
            guard let gunzipped = try? data.gunzipped() else { return nil }
            decompressed = gunzipped
        } else {
            decompressed = data
        }

        guard let firebasePayload = try? FirebasePayload(serializedBytes: decompressed) else { return nil }

        var eventNames: [String] = []
        for batch in firebasePayload.data {
            for event in batch.events {
                if !event.eventName.isEmpty {
                    eventNames.append(event.eventName)
                }
            }
        }

        return eventNames.isEmpty ? nil : eventNames
    }

    /// Builds a synthetic JSON payload for the adaptive sampling matcher.
    /// The `PayloadFlattener` recursively collects all `event_name` values, which the matcher checks against patterns.
    static func buildSyntheticPayload(eventNames: [String]) -> String? {
        guard !eventNames.isEmpty else { return nil }
        let wrapper = SyntheticPayload(events: eventNames.map { SyntheticEvent(event_name: $0) })
        guard let data = try? JSONEncoder().encode(wrapper) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
