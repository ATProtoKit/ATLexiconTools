//
//  XRPCValidationTests.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-03-28.
//

import Foundation
import Testing
@testable import ATLexiconTools

@Suite
struct `XRPC Validation` {

    public var lexiconRegistry: LexiconRegistry

    public init() throws {
        self.lexiconRegistry = try makeLexicons()
    }

    private func makePassingObject() -> PrimitiveValue {
        return .object([
            "object": [
                "boolean": true
            ],
            "array": ["one", "two"],
            "boolean": true,
            "integer": 123,
            "string": "string"
        ])
    }

    @Test
    func `Passes valid parameters`() throws {
        let queryResult = try lexiconRegistry.validateXRPCParameters(
            by: "com.example.query",
            value: .object([
                "boolean": true,
                "integer": 123,
                "string": "string",
                "array": ["x", "y"]
            ])
        )
        #expect(queryResult == .object([
            "boolean": true,
            "integer": 123,
            "string": "string",
            "array": ["x", "y"],
            "def": 0
        ]))

        let procedureResult = try lexiconRegistry.validateXRPCParameters(
            by: "com.example.procedure",
            value: .object([
                "boolean": true,
                "integer": 123,
                "string": "string",
                "array": ["x", "y"],
                "def": 1
            ])
        )
        #expect(procedureResult == .object([
            "boolean": true,
            "integer": 123,
            "string": "string",
            "array": ["x", "y"],
            "def": 1
        ]))
    }

    @Test
    func `Handles required parameters correctly`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateXRPCParameters(
                by: "com.example.query",
                value: .object([
                    "boolean": true,
                    "integer": 123
                ])
            )
        }

        #expect(throws: Error.self) {
            try lexiconRegistry.validateXRPCParameters(
                by: "com.example.query",
                value: .object([
                    "boolean": true
                ])
            )
        }

        #expect(throws: Error.self) {
            try lexiconRegistry.validateXRPCParameters(
                by: "com.example.query",
                value: .object([
                    "boolean": true,
                    "integer": nil
                ])
            )
        }
    }

    @Test
    func `Validates parameter types`() throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateXRPCParameters(
                by: "com.example.query",
                value: .object([
                    "boolean": "string",
                    "integer": 123,
                    "string": "string"
                ])
            )
        }

        #expect(throws: Error.self) {
            try lexiconRegistry.validateXRPCParameters(
                by: "com.example.query",
                value: .object([
                    "boolean": true,
                    "float": 123.45,
                    "integer": 123,
                    "string": "string",
                    "array": "x"
                ])
            )
        }
    }

    @Test
    func `Passes valid inputs`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateXRPCInput(
                by: "com.example.procedure",
                value: makePassingObject()
            )
        }
    }

    @Test
    func `Validates the input`() throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateXRPCInput(
                by: "com.example.procedure",
                value: .object([
                    "object": [
                        "boolean": "string"
                    ],
                    "array": ["one", "two"],
                    "boolean": true,
                    "float": 123.45,
                    "integer": 123,
                    "string": "string"
                ])
            )
        }

        #expect(throws: Error.self) {
            try lexiconRegistry.validateXRPCInput(
                by: "com.example.procedure",
                value: .object([:])
            )
        }
    }

    @Test
    func `Passes valid outputs`() throws {
        #expect(throws: Never.self) {
            try lexiconRegistry.validateXRPCOutput(
                by: "com.example.query",
                value: makePassingObject()
            )
        }

        #expect(throws: Never.self) {
            try lexiconRegistry.validateXRPCOutput(
                by: "com.example.procedure",
                value: makePassingObject()
            )
        }
    }

    @Test
    func `Validates the output`() throws {
        #expect(throws: Error.self) {
            try lexiconRegistry.validateXRPCOutput(
                by: "com.example.query",
                value: .object([
                    "object": [
                        "boolean": "string"
                    ],
                    "array": ["one", "two"],
                    "boolean": true,
                    "float": 123.45,
                    "integer": 123,
                    "string": "string"
                ])
            )
        }

        #expect(throws: Error.self) {
            try lexiconRegistry.validateXRPCOutput(
                by: "com.example.procedure",
                value: .object([:])
            )
        }
    }
}
