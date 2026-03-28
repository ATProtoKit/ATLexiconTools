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

    @Test
    func `Fails incorrect $type`() throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(by: "com.example.kitchenSink")
        }

        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: [
                    "type": "foo"
                ])
        }
    }

    @Test
    func `Fails missing 'required' fields`() throws {
        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: .object([
                    "$type" : "com.example.kitchenSink",
                    "array": ["one", "two"],
                    "boolean": true,
                    "integer": 123,
                    "string": "string",
                    "datetime" : .string("\(Date.now.ISO8601Format())"),
                    "atUri" : "at://did:web:example.com/com.example.test/self",
                    "did": "did:web:example.com",
                    "cid": "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a",
                    "bytes": .bytes(Data([0, 1, 2, 3])),
                    "cidLink": .cid(try CID(string: "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"))
                ])
            )
        }
    }

    @Test
    func `Fails incorrect types`() throws {
        #expect(throws: LexiconValidatorError.self, "Record/object/object/boolean must be a boolean.") {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: .object([
                    "$type": "com.example.kitchenSink",
                    "object": [
                        "object": ["boolean": "1234"],
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
            )
        }

        #expect(throws: LexiconValidatorError.self, "Record/object must be an object.") {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: .object([
                    "$type": "com.example.kitchenSink",
                    "object": true,
                    "array": ["one", "two"],
                    "boolean": true,
                    "integer": 123,
                    "string": "string",
                    "bytes": .bytes(Data([0, 1, 2, 3])),
                    "cidLink": .cid(try CID(string: "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"))
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self, "Record/array must be an array.") {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: .object([
                    "$type": "com.example.kitchenSink",
                    "object": [
                        "object": ["boolean": true],
                        "array": ["one", "two"],
                        "boolean": true,
                        "integer": 123,
                        "string": "string"
                    ],
                    "array": 1234,
                    "boolean": true,
                    "integer": 123,
                    "string": "string",
                    "bytes": .bytes(Data([0, 1, 2, 3])),
                    "cidLink": .cid(try CID(string: "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"))
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self, "Record/integer must be an integer.") {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: .object([
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
                    "integer": true,
                    "string": "string",
                    "bytes": .bytes(Data([0, 1, 2, 3])),
                    "cidLink": .cid(try CID(string: "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"))
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self, "Record/string must be a string.") {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: .object([
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
                    "string": ["test": 1234],
                    "bytes": .bytes(Data([0, 1, 2, 3])),
                    "cidLink": .cid(try CID(string: "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"))
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self, "Record/bytes must be a byte array.") {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: .object([
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
                    "bytes": 1234,
                    "cidLink": .cid(try CID(string: "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"))
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self, "Record/cidLink must be a CID.") {
            try lexiconRegistry.validateRecord(
                by: "com.example.kitchenSink",
                value: .object([
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
                    "cidLink": "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"
                ])
            )
        }
    }

    @Test
    func `Handles optional properties correctly`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.optional",
                value: .object([
                    "$type": "com.example.optional"
                ])
            )
        }
    }

    @Test
    func `Handles default properties correctly`() throws {
        let validatedRecord = try lexiconRegistry.validateRecord(
            by: "com.example.default",
            value: .object([
                "$type": "com.example.default",
                "object": [:]
            ])
        )

        #expect(validatedRecord == .object([
            "$type": "com.example.default",
            "boolean": false,
            "integer": 0,
            "string": "",
            "object": [
                "boolean": true,
                "integer": 1,
                "string": "x"
            ]
        ]))
    }

    @Test
    func `Handles unions correctly`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.union",
                value: .object([
                    "$type": "com.example.union",
                    "unionOpen": [
                        "$type": "com.example.kitchenSink#object",
                        "object": ["boolean": true],
                        "array": ["one", "two"],
                        "boolean": true,
                        "integer": 123,
                        "string": "string"
                    ],
                    "unionClosed": [
                        "$type": "com.example.kitchenSink#subobject",
                        "boolean": true
                    ]
                ])
            )
        }

        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.union",
                value: .object([
                    "$type": "com.example.union",
                    "unionOpen": [
                        "$type": "com.example.other"
                    ],
                    "unionClosed": [
                        "$type": "com.example.kitchenSink#subobject",
                        "boolean": true
                    ]
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.union",
                value: .object([
                    "$type": "com.example.union",
                    "unionOpen": [:],
                    "unionClosed": [:]
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.union",
                value: .object([
                    "$type": "com.example.union",
                    "unionOpen": [
                        "$type": "com.example.other"
                    ],
                    "unionClosed": [
                        "$type": "com.example.other",
                        "boolean": true
                    ]
                ])
            )
        }
    }
}
