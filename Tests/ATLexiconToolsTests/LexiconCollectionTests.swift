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
        #expect(throws: LexiconRegistryError.lexiconAlreadyRegistered(nsid: uri)) {
            try lexiconRegistry.add(lexicon: firstLexicon)
        }
    }
}
