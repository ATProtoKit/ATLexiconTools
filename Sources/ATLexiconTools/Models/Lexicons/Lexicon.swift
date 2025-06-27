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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.lexicon = try container.decode(Int.self, forKey: .lexicon)
        self.id = try container.decode(String.self, forKey: .id)

        guard NSIDValidator.isValid(self.id) == true else {
            throw DecodingError.dataCorruptedError(
                forKey: .id,
                in: container,
                debugDescription: "'\(self.id)' is not a valid NSID."
            )
        }

        self.revision = try container.decodeIfPresent(Int.self, forKey: .revision)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.definitions = try container.decode([String: LexiconDefinition].self, forKey: .definitions)

        for (key, definition) in self.definitions {
            switch definition {
                case .record, .query, .procedure, .subscription:
                    if key != "main" {
                        throw DecodingError.dataCorruptedError(
                            forKey: .definitions,
                            in: container,
                            debugDescription: "Records, procedures, queries, and subscriptions must be the main definition (found '\(key)' instead)."
                        )
                    }
                default:
                    continue
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case lexicon
        case id
        case revision
        case description
        case definitions = "defs"
    }
}
