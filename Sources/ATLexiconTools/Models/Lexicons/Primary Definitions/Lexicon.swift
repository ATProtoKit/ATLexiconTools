//
//  Lexicon.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation
import ATSyntaxTools

/// A structure representing the lexicon.
public struct Lexicon: Codable {

    /// The Lexicon Language version number.
    ///
    /// At this time, the value will be `1`.
    public let lexicon: Int

    /// The Namespaced Identifier (NSID) of the lexicon.
    public let id: String

    /// The revision number of the lexicon to denote changes. Optional.
    public let revision: Int?

    /// A short description of the lexicon. Optional.
    public let description: String?

    /// A dictionary of definitions within the lexicon.
    public let definitions: [String: LexiconDefinition]

    enum CodingKeys: String, CodingKey {
        case lexicon
        case id
        case revision
        case description
        case definitions = "defs"
    }
}
