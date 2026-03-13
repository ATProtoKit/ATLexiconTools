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
        let firstLexicon = lexicons[0]

        let uri = try LexiconToolsUtilities.toLexiconURI(from: firstLexicon.id)
        #expect(throws: LexiconRegistryError.lexiconAlreadyRegistered(nsid: uri), "\"\(uri)\" should be a duplicate.") {
            try lexiconRegistry.add(lexicon: firstLexicon)
        }
    }

    @Test
    func `Correctly references all definitions`() async throws {
        try #require(
            lexiconRegistry.getDefinition(by: "com.example.kitchenSink").type == lexicons[0].definitions["main"]?.type,
            "\"com.example.kitchenSink\" not found in lexicon registry."
        )

        try #require(
            lexiconRegistry.getDefinition(by: "lex:com.example.kitchenSink").type == lexicons[0].definitions["main"]?.type,
            "\"lex:com.example.kitchenSink\" not found in lexicon registry."
        )

        try #require(
            lexiconRegistry.getDefinition(by: "com.example.kitchenSink#main").type == lexicons[0].definitions["main"]?.type,
            "\"com.example.kitchenSink#main\" not found in lexicon registry."
        )

        try #require(
            lexiconRegistry.getDefinition(by: "lex:com.example.kitchenSink#main").type == lexicons[0].definitions["main"]?.type,
            "\"lex:com.example.kitchenSink#main\" not found in lexicon registry."
        )

        try #require(
            lexiconRegistry.getDefinition(by: "com.example.kitchenSink#object").type == lexicons[0].definitions["object"]?.type,
            "\"com.example.kitchenSink#object\" not found in lexicon registry."
        )

        try #require(
            lexiconRegistry.getDefinition(by: "lex:com.example.kitchenSink#object").type == lexicons[0].definitions["object"]?.type,
            "\"lex:com.example.kitchenSink#object\" not found in lexicon registry."
        )
    }
}
