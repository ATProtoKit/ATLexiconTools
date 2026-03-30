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

        #expect(throws: Error.self, "Record should be validated.") {
            try self.lexiconRegistry.validate(lexiconURI: "com.example.kitchenSink")
        }
    }

    @Test
    func `Validates objects correctly`() throws {
        #expect(throws: Never.self, "Object should be validated.") {
            try self.lexiconRegistry.validate(
                lexiconURI: "com.example.kitchenSink#object",
                value: [
                    "object" : ["boolean": true],
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

        #expect(throws: Error.self, "The required property 'foo' should not be found.") {
            _ = try LexiconParser.parseLexicon(schema)
        }
    }

    @Test
    func `Allows unknown fields to be present`() throws {
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

        #expect(throws: Never.self, "\"foo\" should be allowed to be in the achema.") {
            _ = try LexiconParser.parseLexicon(schema)
        }
    }

    @Test
    func `Fails lexicon parsing when URI is invalid`() throws {
        let schema = """
            {
                "lexicon": 1,
                "id": "com.example.invalidUri",
                "defs": {
                    "main": {
                        "$type": "object",
                        "properties": {
                            "test": {
                                "$type": "ref",
                                "ref": "com.example.invalid#test#test"
                            }
                        }
                    }
                }
            }
            """

        #expect(throws: Error.self, "The URI in the schema should be invalid.") {
            _ = try LexiconParser.parseLexicon(schema)
        }
    }

    @Test
    func `Fails validation when 'ref' URI has multiple hash segments`() throws {
        let schema = try Lexicon(
            lexicon: 1,
            id: "com.example.invalidUri",
            definitions: [
                "main": .object(
                    ATObjectType(
                        properties: ["test": .union(
                            ATUnionType(
                                references: ["com.example.invalidUri"]
                            ))],
                        required: ["test"]
                    )
                )
            ]
        )

        let lexicons = try LexiconRegistry(lexicons: [schema])

        #expect(throws: Error.self, "The URI in the \"ref\" key inside the schema should be invalid.") {
            try lexicons.validate(
                lexiconURI: "com.example.invalidUri#object",
                value: [
                    "test": [
                        "$type": "com.example.invalidUri#main#main",
                        "test": 123
                    ]
                ]
            )
        }
    }

    @Test
    func `Union handles both implicit and explicit #main`() throws {
        let schemas: [Lexicon] = [
            try Lexicon(
                lexicon: 1,
                id: "com.example.implicitMain",
                definitions: [
                    "main" : .object(ATObjectType(
                        properties: [
                            "test" : .string(ATStringType())
                        ],
                        required: ["test"]
                    ))
                ]
            ),
            try Lexicon(
                lexicon: 1,
                id: "com.example.testImplicitMain",
                definitions: [
                    "main" : .object(ATObjectType(
                        properties: [
                            "union" : .reference(
                                ATReferenceType(reference: "com.example.implicitMain")
                            )
                        ],
                        required: ["union"]
                    ))
                ]
            ),
            try Lexicon(
                lexicon: 1,
                id: "com.example.testExplicitMain",
                definitions: [
                    "main" : .object(ATObjectType(
                        properties: [
                            "union" : .reference(
                                ATReferenceType(reference: "com.example.implicitMain#main")
                            )
                        ],
                        required: ["union"]
                    ))
                ])
        ]

        let lexicons = try LexiconRegistry(lexicons: schemas)

        #expect(throws: LexiconValidatorError.self, "Object/union/test in com.example.implicitMain must be a string.") {
            try lexicons.validate(
                lexiconURI: "com.example.testImplicitMain",
                value: [
                    "union": [
                        "$type": "com.example.implicitMain",
                        "test": 123
                    ]
                ])
        }

        #expect(throws: LexiconValidatorError.self, "Object/union/test in com.example.implicitMain#main must be a string.") {
            try lexicons.validate(
                lexiconURI: "com.example.testImplicitMain",
                value: [
                    "union": [
                        "$type": "com.example.implicitMain#main",
                        "test": 123
                    ]
                ])
        }

        #expect(throws: LexiconValidatorError.self, "Object/union/test in com.example.implicitMain#main must be a string.") {
            try lexicons.validate(
                lexiconURI: "com.example.testExplicitMain",
                value: [
                    "union": [
                        "$type": "com.example.implicitMain#main",
                        "test": 123
                    ]
                ])
        }

        #expect(throws: LexiconValidatorError.self, "Object/union/test in com.example.implicitMain#main must be a string.") {
            try lexicons.validate(
                lexiconURI: "com.example.testExplicitMain",
                value: [
                    "union": [
                        "$type": "com.example.implicitMain#main",
                        "test": 123
                    ]
                ])
        }
    }
}
