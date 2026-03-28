//
//  Lexicon.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation
import ATSyntaxTools

/// A structure representing the lexicon.
public struct Lexicon: Codable, Sendable {

    /// The NSID type for compatibility with publishing lexicons. Optional.
    ///
    /// By default, the value will be "`com.atproto.lexicon.schema`".
    public let type: String? = "com.atproto.lexicon.schema"

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

    /// Creates an instance of `Lexicon`.
    ///
    /// - Parameters:
    ///   - lexicon: The Lexicon Language version number.
    ///   - id: The Namespaced Identifier (NSID) of the lexicon.
    ///   - revision: The revision number of the lexicon to denote changes. Optional. Defaults to `nil`.
    ///   - description: A short description of the lexicon. Optional. Defaults to `nil`.
    ///   - definitions: A dictionary of definitions within the lexicon.
    ///
    /// - Throws: An error if a value is violating the lexicon requirements.
    public init(lexicon: Int, id: String, revision: Int? = nil, description: String? = nil, definitions: [String : LexiconDefinition]) throws {
        self.lexicon = lexicon
        self.id = id
        self.revision = revision
        self.description = description
        self.definitions = definitions

        try validate()
        try Self.validate(id: self.id)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.lexicon = try container.decode(Int.self, forKey: .lexicon)
        self.id = try container.decode(String.self, forKey: .id)

        try Self.validate(id: self.id, container: container)

        self.revision = try container.decodeIfPresent(Int.self, forKey: .revision)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.definitions = try container.decode([String: LexiconDefinition].self, forKey: .definitions)

        try validate(container)
    }

    enum CodingKeys: String, CodingKey {
        case lexicon
        case id
        case revision
        case description
        case definitions = "defs"
    }

    // MARK: - Validators

    /// Validates the current level of the lexicon.
    ///
    /// - Parameter container: A keyed decoding container view into this decoder. Optional. Defaults to `nil`.
    ///
    /// - Throws: An error if the encountered stored value is not in the "main" definition.
    private func validate(_ container: KeyedDecodingContainer<Lexicon.CodingKeys>? = nil) throws {
        for (key, definition) in definitions {
            switch definition {
                case .record, .query, .procedure, .subscription:
                    if key != "main" {
                        if let container = container {
                            throw DecodingError.dataCorruptedError(
                                forKey: .definitions,
                                in: container,
                                debugDescription: "Records, procedures, queries, and subscriptions must be in the 'main' definition (found '\(key)' instead)."
                            )
                        } else {
                            throw LexiconSchemaValidatorError.invalidSchema(
                                reason: "Records, procedures, queries, and subscriptions must be in the 'main' definition (found '\(key)' instead).")
                        }

                    }
                default:
                    continue
            }
        }
    }

    /// Validates the Namespaced Identifier (NSID) of the lexicon.
    ///
    /// - Parameters:
    ///   - id: The NSID of the lexicon.
    ///   - container: A keyed decoding container view into this decoder.
    ///
    /// - Throws: An error if the encountered stored value is invalid.
    private static func validate(id: String, container: KeyedDecodingContainer<Lexicon.CodingKeys>? = nil) throws {
        guard NSIDValidator.isValid(id) else {
            if let container = container {
                throw DecodingError.dataCorruptedError(
                    forKey: .id,
                    in: container,
                    debugDescription: "The NSID provided is invalid."
                )
            } else {
                throw LexiconSchemaValidatorError.invalidSchema(reason: "The NSID provided is invalid.")
            }
        }
    }
}
