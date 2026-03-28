//
//  XRPCParameterValidationTests.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-03-28.
//

import Foundation
import Testing
@testable import ATLexiconTools

@Suite
struct `XRPC Parameter Validation` {

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
}
