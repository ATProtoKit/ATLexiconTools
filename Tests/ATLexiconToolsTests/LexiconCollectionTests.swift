//
//  LexiconCollectionTests.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-03-07.
//

import Foundation
import Testing
import MultiformatsKit
@testable import ATLexiconTools

@Suite("Lexicon Collection")
struct LexiconCollectionTests {

    public var lexiconRegistry: LexiconRegistry

    public init() async throws {
        self.lexiconRegistry = try makeLexicons()
    }

    @Test
    func `Registry rejects duplicate lexicons`() throws {
        let firstLexicon = try generateLexiconScaffolds()[0]

        let uri = try LexiconToolsUtilities.toLexiconURI(from: firstLexicon.id)
        #expect(throws: LexiconRegistryError.lexiconAlreadyRegistered(nsid: uri), "\"\(uri)\" should be a duplicate.") {
            try lexiconRegistry.add(lexicon: firstLexicon)
        }
    }

    @Test
    func `Correctly references all definitions`() async throws {
        #expect(throws: Never.self, "\"com.example.kitchenSink\" not found in lexicon registry.") {
            try lexiconRegistry
                .getDefinition(by: "com.example.kitchenSink", shouldNormalizeURI: true).type == generateLexiconScaffolds()[0]
                .definitions["main"]?.type
        }

        #expect(throws: Never.self, "\"lex:com.example.kitchenSink\" not found in lexicon registry.") {
            try lexiconRegistry.getDefinition(by: "lex:com.example.kitchenSink").type == generateLexiconScaffolds()[0].definitions["main"]?.type
        }

        #expect(throws: Never.self, "\"com.example.kitchenSink#main\" not found in lexicon registry.") {
            try lexiconRegistry.getDefinition(by: "com.example.kitchenSink#main", shouldNormalizeURI: true).type == generateLexiconScaffolds()[0].definitions["main"]?.type
        }

        #expect(throws: Never.self, "\"lex:com.example.kitchenSink#main\" not found in lexicon registry.") {
            try lexiconRegistry.getDefinition(by: "lex:com.example.kitchenSink#main").type == generateLexiconScaffolds()[0].definitions["main"]?.type
        }

        #expect(throws: Never.self, "\"com.example.kitchenSink#object\" not found in lexicon registry.") {
            try lexiconRegistry.getDefinition(by: "com.example.kitchenSink#object", shouldNormalizeURI: true).type == generateLexiconScaffolds()[0].definitions["object"]?.type
        }

        #expect(throws: Never.self, "\"lex:com.example.kitchenSink#object\" not found in lexicon registry.") {
            try lexiconRegistry.getDefinition(by: "lex:com.example.kitchenSink#object").type == generateLexiconScaffolds()[0].definitions["object"]?.type
        }
    }
}
