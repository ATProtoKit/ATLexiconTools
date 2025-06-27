//
//  LexiconParser.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A namespace group of methods for parsing lexicon models to their `Lexicon` representations.
public enum LexiconParser {

    /// Parses a single lexicon JSON.
    ///
    /// - Parameter lexicon: A lexicon JSON.
    /// - Returns: An array of `Lexicon` models.
    ///
    /// - Throws: An error if the decoding fails, such as if the Namespaced Identifier (NSID) is invalid,
    /// the JSON is not structured correctly, or the lexicon is somehow violating any lexicon requirements.
    public static func parseLexicon(_ lexicon: String) throws -> Lexicon {
        guard let lexiconData = lexicon.data(using: .utf8) else {
            throw LexiconToolsError.invalidLexicon
        }

        let decoder = JSONDecoder()
        let lexicon = try decoder.decode(Lexicon.self, from: lexiconData)

        return lexicon
    }

    /// Parses multiple lexicon JSONs.
    ///
    /// - Parameter lexicons: An array of lexicon JSONs.
    /// - Returns: An array of `Lexicon` models.
    ///
    /// - Throws: An error if the decoding fails, such as if the Namespaced Identifier (NSID) is invalid,
    /// the JSON is not structured correctly, or the lexicon is somehow violating any lexicon requirements.
    public static func parseMultipleLexicons(_ lexicons: [String]) throws -> [Lexicon] {
        var lexiconResults: [Lexicon] = []

        for lexicon in lexicons {
            lexiconResults.append(try Self.parseLexicon(lexicon))
        }

        return lexiconResults
    }
}
