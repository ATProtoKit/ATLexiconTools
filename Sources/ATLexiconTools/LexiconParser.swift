//
//  LexiconParser.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A collection of utility methods for converting lexicon JSON into their `Lexicon` representations.
///
/// Use `parseLexicon(_:keyDecodingStrategy:)` to decode a single lexicon JSON string into a `Lexicon`.
/// If there are multiple lexicon JSON strings, use `parseMultipleLexicons(_:keyDecodingStrategy:)` to
/// decode them all in order. To quickly check if a lexicon JSON is structurally valid without needing the
/// decoded result, use `isLexiconValid(_:)`.
///
/// Decoding behavior can be customized via `JSONDecoder.KeyDecodingStrategy`. By default, the parser
/// uses `.useDefaultKeys`, which expects the JSON keys to match the `Lexicon` model’s coding keys exactly.
/// If your JSON uses a different key style (e.g., snake case), pass an appropriate strategy.
///
/// ## Example
/// ```swift
/// let json = "{ ... }"
///
/// do {
///     let lexicon = try LexiconParser.parseLexicon(json)
///     print(lexicon)
/// } catch {
///     print(error)
/// }
/// ```
///
/// ## Validation-only
/// ```swift
/// if LexiconParser.isLexiconValid(json) {
///     // Proceed
/// }
/// ```
public enum LexiconParser {

    /// Parses a single lexicon JSON.
    ///
    /// - Parameters:
    ///   - lexicon: A lexicon JSON.
    ///   - keyDecodingStrategy: A value that determines how to decode a lexicon's coding keys from
    ///   JSON keys. Defaults to `.useDefaultKeys`.
    /// - Returns: An array of `Lexicon` models.
    ///
    /// - Throws: An error if the decoding fails, such as if the Namespaced Identifier (NSID) is invalid,
    /// the JSON is not structured correctly, or the lexicon is somehow violating any lexicon requirements.
    public static func parseLexicon(_ lexicon: String, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> Lexicon {
        guard let lexiconData = lexicon.data(using: .utf8) else {
            throw LexiconToolsError.invalidLexicon
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        let lexicon = try decoder.decode(Lexicon.self, from: lexiconData)

        return lexicon
    }

    /// Parses multiple lexicon JSONs.
    ///
    /// - Parameters:
    ///   - lexicons: An array of lexicon JSONs.
    ///   - keyDecodingStrategy: A value that determines how to decode a lexicon's coding keys from
    ///   JSON keys. Defaults to `.useDefaultKeys`.
    /// - Returns: An array of `Lexicon` models.
    ///
    /// - Throws: An error if the decoding fails.
    public static func parseMultipleLexicons(
        _ lexicons: [String],
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) throws -> [Lexicon] {
        var lexiconResults: [Lexicon] = []

        for lexicon in lexicons {
            lexiconResults.append(try Self.parseLexicon(lexicon, keyDecodingStrategy: keyDecodingStrategy))
        }

        return lexiconResults
    }

    /// Determines whether the lexicon JSON is valid.
    ///
    /// This method assumes that the default keys are being used to decode the JSON keys.
    ///
    /// - Parameter lexicon: The lexicon JSON to validate.
    /// - Returns: `true` if the lexicon is valid, or `false` if not.
    public static func isLexiconValid(_ lexicon: String) -> Bool {
        do {
            _ = try Self.parseLexicon(lexicon)

            return true
        } catch {
            return false
        }
    }
}
