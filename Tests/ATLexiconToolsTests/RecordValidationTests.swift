//
//  RecordValidationTests.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-03-18.
//

import Foundation
import Testing
import MultiformatsKit
@testable import ATLexiconTools

@Suite
struct `Record Validation` {

    public var lexiconRegistry: LexiconRegistry

    public init() throws {
        self.lexiconRegistry = try makeLexicons()
    }

    private func makePassingSink() throws -> PrimitiveValue {
        return .object([
            "$type": "com.example.kitchenSink",
            "object": [
                "object": ["boolean": true],
                "array": ["one", "two"],
                "boolean": true,
                "integer": 123,
                "string": "string"
            ],
            "array": ["one", "two"],
            "boolean": true,
            "integer": 123,
            "string": "string",
            "bytes": .bytes(Data([0, 1, 2, 3])),
            "cidLink": .cid(try CID(string: "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"))
        ])
    }

    @Test
    func `Passes valid schemas`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: makePassingSink()
            )
        }
    }

    @Test
    func `Fails invalid input types`() throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(by: "com.example.kitchenSink")
        }

        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(by: "com.example.kitchenSink", value: 123)
        }

        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(by: "com.example.kitchenSink", value: "string")
        }
    }

}
