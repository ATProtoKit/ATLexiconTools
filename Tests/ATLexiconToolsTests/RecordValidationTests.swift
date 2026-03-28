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

    @Test
    func `Handles unknowns correctly`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.unknown",
                value: .object([
                    "$type": "com.example.unknown",
                    "unknown": [
                        "foo": "bar"
                    ]
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.unknown",
                value: .object([
                    "$type": "com.example.unknown"
                ])
            )
        }
    }

    @Test
    func `Applies array length constraints`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.arrayLength",
                value: .object([
                    "$type": "com.example.arrayLength",
                    "array": [1, 2, 3]
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.arrayLength",
                value: .object([
                    "$type": "com.example.arrayLength",
                    "array": [1]
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.arrayLength",
                value: .object([
                    "$type": "com.example.arrayLength",
                    "array": [1, 2, 3, 4, 5]
                ])
            )
        }
    }

    @Test
    func `Applies array item constraints`() throws {
        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.arrayLength",
                value: .object([
                    "$type": "com.example.arrayLength",
                    "array": [1, "2", 3]
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.arrayLength",
                value: .object([
                    "$type": "com.example.arrayLength",
                    "array": [1, nil, 3]
                ])
            )
        }
    }

    @Test
    func `Applies boolean constant constraint`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.boolConst",
                value: .object([
                    "$type": "com.example.boolConst",
                    "boolean": false
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.boolConst",
                value: .object([
                    "$type": "com.example.boolConst",
                    "boolean": true
                ])
            )
        }
    }

    @Test
    func `Applies integer range constraint`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.integerRange",
                value: .object([
                    "$type": "com.example.integerRange",
                    "integer": 2
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.integerRange",
                value: .object([
                    "$type": "com.example.integerRange",
                    "integer": 1
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.integerRange",
                value: .object([
                    "$type": "com.example.integerRange",
                    "integer": 5
                ])
            )
        }
    }

    @Test
    func `Applies integer enum constraint`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.integerEnum",
                value: .object([
                    "$type": "com.example.integerEnum",
                    "integer": 2
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.integerEnum",
                value: .object([
                    "$type": "com.example.integerEnum",
                    "integer": 0
                ])
            )
        }
    }

    @Test
    func `Applies integer constant constraint`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.integerConst",
                value: .object([
                    "$type": "com.example.integerConst",
                    "integer": 0
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.integerConst",
                value: .object([
                    "$type": "com.example.integerConst",
                    "integer": 1
                ])
            )
        }
    }

    @Test
    func `Applies integer whole-number constraint`() throws {
        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.integerRange",
                value: .object([
                    "$type": "com.example.integerRange",
                    "integer": 2.5
                ])
            )
        }
    }

    @Test(arguments: [
        "ab",
        "\u{0301}",
        "a\u{0301}",
        "aé",
        "abc",
        "一",
        "�",
        "abcd",
        "éé",
        "aaé",
        "👋"
    ])
    func `Applies string length constraint (valid)`(value: String) throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.stringLength",
                value: .object([
                    "$type": "com.example.stringLength",
                    "string": .string(value)
                ])
            )
        }
    }

    @Test(arguments: [
        "",
        "a",
        "abcde",
        "a\u{0301}\u{0301}",
        "��",
        "ééé",
        "👋a",
        "👨👨",
        "👨‍👩‍👧‍👧"
    ])
    func `Applies string length constraint (invalid)`(value: String) throws {
        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.stringLength",
                value: .object([
                    "$type": "com.example.stringLength",
                    "string": .string(value)
                ])
            )
        }
    }

    @Test(arguments: [
        "",
        "a",
        "ab",
        "\u{0301}",
        "a\u{0301}",
        "aé",
        "abc",
        "一",
        "�",
        "abcd",
        "éé",
        "aaé",
        "👋"
    ])
    func `Applies string length constraint with no minimum (valid)`(value: String) throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.stringLengthNoMinLength",
                value: .object([
                    "$type": "com.example.stringLengthNoMinLength",
                    "string": .string(value)
                ])
            )
        }
    }

    @Test(arguments: [
        "abcde",
        "a\u{0301}\u{0301}",
        "��",
        "ééé",
        "👋a",
        "👨👨",
        "👨‍👩‍👧‍👧"
    ])
    func `Applies string length constraint with no minimum (invalid)`(value: String) throws {
        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.stringLengthNoMinLength",
                value: .object([
                    "$type": "com.example.stringLengthNoMinLength",
                    "string": .string(value)
                ])
            )
        }
    }

    @Test(arguments: [
        "ab",
        "a\u{0301}b",
        "a\u{0301}b\u{0301}",
        "😀😀",
        "12👨‍👩‍👧‍👧",
        "abcd",
        "a\u{0301}b\u{0301}c\u{0301}d\u{0301}"
    ])
    func `Applies grapheme string length constraint (valid)`(value: String) throws {
        _ = try lexiconRegistry.validateRecord(
            by: "com.example.stringLengthGrapheme",
            value: .object([
                "$type": "com.example.stringLengthGrapheme",
                "string": .string(value)
            ])
        )
    }

    @Test(arguments: [
        "",
        "\u{0301}\u{0301}\u{0301}",
        "a",
        "a\u{0301}\u{0301}\u{0301}\u{0301}",
        "5\u{FE0F}",
        "👨‍👩‍👧‍👧",
        "abcde",
        "a\u{0301}b\u{0301}c\u{0301}d\u{0301}e\u{0301}",
        "😀😀😀😀😀",
        "ab😀de"
    ])
    func `Applies grapheme string length constraint (invalid)`(value: String) throws {
        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.stringLengthGrapheme",
                value: .object([
                    "$type": "com.example.stringLengthGrapheme",
                    "string": .string(value)
                ])
            )
        }
    }

    @Test
    func `Applies string enum constraint`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.stringEnum",
                value: .object([
                    "$type": "com.example.stringEnum",
                    "string": "a"
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.stringEnum",
                value: .object([
                    "$type": "com.example.stringEnum",
                    "string": "c"
                ])
            )
        }
    }

    @Test
    func `Applies string constant constraint`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.stringConst",
                value: .object([
                    "$type": "com.example.stringConst",
                    "string": "a"
                ])
            )
        }

        #expect(throws: LexiconValidatorError.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.stringConst",
                value: .object([
                    "$type": "com.example.stringConst",
                    "string": "b"
                ])
            )
        }
    }

    @Test(arguments: [
        "2022-12-12T00:50:36.809Z",
        "2022-12-12T00:50:36Z",
        "2022-12-12T00:50:36.8Z",
        "2022-12-12T00:50:36.80Z",
        "2022-12-12T00:50:36+00:00",
        "2022-12-12T00:50:36.8+00:00",
        "2022-12-11T19:50:36-05:00",
        "2022-12-11T19:50:36.8-05:00",
        "2022-12-11T19:50:36.80-05:00",
        "2022-12-11T19:50:36.809-05:00"
    ])
    func `Applies datetime formatting constraint (valid)`(value: String) throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.datetime",
                value: .object([
                    "$type": "com.example.datetime",
                    "datetime": .string(value)
                ])
            )
        }
    }

    @Test
    func `Applies datetime formatting constraint (invalid)`() throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.datetime",
                value: .object([
                    "$type": "com.example.datetime",
                    "datetime": "bad date"
                ])
            )
        }
    }

    @Test(arguments: [
        "https://example.com",
        "https://example.com/with/path",
        "https://example.com/with/path?and=query",
        "at://bsky.social",
        "did:example:test"
    ])
    func `Applies URI formatting constraint (valid)`(value: String) throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.uri",
                value: .object([
                    "$type": "com.example.uri",
                    "uri": .string(value)
                ])
            )
        }
    }

    @Test
    func `Applies URI formatting constraint (invalid)`() throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.uri",
                value: .object([
                    "$type": "com.example.uri",
                    "uri": "not a uri"
                ])
            )
        }
    }

    @Test
    func `Applies AT-URI formatting constraint`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.atUri",
                value: .object([
                    "$type": "com.example.atUri",
                    "atUri": "at://did:web:example.com/com.example.test/self"
                ])
            )
        }

        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.atUri",
                value: .object([
                    "$type": "com.example.atUri",
                    "atUri": "http://not-atproto.com"
                ])
            )
        }
    }

    @Test(arguments: [
        "did:web:example.com",
        "did:plc:12345678abcdefghijklmnop"
    ])
    func `Applies DID formatting constraint (valid)`(value: String) throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.did",
                value: .object([
                    "$type": "com.example.did",
                    "did": .string(value)
                ])
            )
        }
    }

    @Test(arguments: [
        "bad did",
        "did:short"
    ])
    func `Applies DID formatting constraint (invalid)`(value: String) throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.did",
                value: .object([
                    "$type": "com.example.did",
                    "did": .string(value)
                ])
            )
        }
    }

    @Test(arguments: [
        "test.bsky.social",
        "bsky.test"
    ])
    func `Applies handle formatting constraint (valid)`(value: String) throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.handle",
                value: .object([
                    "$type": "com.example.handle",
                    "handle": .string(value)
                ])
            )
        }
    }

    @Test(arguments: [
        "bad handle",
        "-bad-.test"
    ])
    func `Applies handle formatting constraint (invalid)`(value: String) throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.handle",
                value: .object([
                    "$type": "com.example.handle",
                    "handle": .string(value)
                ])
            )
        }
    }

    @Test(arguments: [
        "bsky.test",
        "did:plc:12345678abcdefghijklmnop"
    ])
    func `Applies AT-identifier formatting constraint (valid)`(value: String) throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.atIdentifier",
                value: .object([
                    "$type": "com.example.atIdentifier",
                    "atIdentifier": .string(value)
                ])
            )
        }
    }

    @Test(arguments: [
        "bad id",
        "-bad-.test"
    ])
    func `Applies AT-identifier formatting constraint (invalid)`(value: String) throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateRecord(
                by: "com.example.atIdentifier",
                value: .object([
                    "$type": "com.example.atIdentifier",
                    "atIdentifier": .string(value)
                ])
            )
        }
    }
}
