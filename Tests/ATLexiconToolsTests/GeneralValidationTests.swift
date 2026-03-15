//
//  GeneralValidationTests.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-03-13.
//

import Foundation
import Testing
import MultiformatsKit
@testable import ATLexiconTools

@Suite
struct `General Validation` {

    public var lexiconRegistry: LexiconRegistry

    public init() throws {
        self.lexiconRegistry = try makeLexicons()
    }

    @Test
    func `Validates records correctly`() throws {
        #expect(throws: Never.self) {
            try self.lexiconRegistry.validate(
                lexiconURI: "com.example.kitchenSink",
                value: .object([
                    "$type" : "com.example.kitchenSink",
                    "object" : [
                        "object" : ["boolean": true],
                        "array" : ["one", "two"],
                        "boolean" : true,
                        "integer" : 123,
                        "string" : "string"
                    ],
                    "array" : ["one", "two"],
                    "boolean" : true,
                    "integer" : 123,
                    "string" : "string",
                    "datetime" : .string("\(Date.now.ISO8601Format())"),
                    "atUri" : "at://did:web:example.com/com.example.test/self",
                    "did" : "did:web:example.com",
                    "cid" : "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a",
                    "bytes": .bytes(Data([0, 1, 2, 3])),
                    "cidLink": .cid(try CID(string: "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"))
                ]))
        }

        #expect(throws: Error.self) {
            try self.lexiconRegistry.validate(lexiconURI: "com.example.kitchenSink")
        }
    }

    @Test
    func `Validates objects correctly`() throws {
        #expect(throws: Never.self) {
            try self.lexiconRegistry.validate(
                lexiconURI: "com.example.kitchenSink#object",
                value: ["object" : ["boolean": true],
                        "array": ["one", "two"],
                        "boolean": true,
                        "integer": 123,
                        "string": "string"
                       ]
            )
        }

        #expect(throws: Error.self) {
            try self.lexiconRegistry.validate(lexiconURI: "com.example.kitchenSink#object")
        }
    }

    @Test
    func `Fails when a required property is missing`() throws {
        let schema = """
            {
                "lexicon": 1,
                "id": "com.example.kitchenSink",
                "defs": {
                    "test": {
                        "$type": "object",
                        "required": ["foo"],
                        "properties": {}
                    }
                }
            }
            """

        #expect(throws: Never.self) {
            _ = try LexiconParser.parseLexicon(schema)
        }
    }

    @Test
    func `Allows unknown fields to be present`() async throws {
        let schema = """
            {
                "lexicon": 1,
                "id": "ccom.example.unknownFields",
                "defs": {
                    "test": {
                        "$type": "object",
                        "properties": {},
                        "foo": 3,
                    }
                }
            }
            """

        #expect(throws: Never.self) {
            _ = try LexiconParser.parseLexicon(schema)
        }
    }
}
