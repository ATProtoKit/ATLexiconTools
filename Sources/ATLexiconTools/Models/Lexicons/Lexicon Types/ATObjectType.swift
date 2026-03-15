//
//  ATObjectType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// An `object` type.
///
/// This is a generic object schema that can be referenced inside other definitions.
///
/// In Swift, this would be the equivalent to a `struct` or `class`.
public struct ATObjectType: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `object`.
    public var type: String { "object" }

    /// A short description of the object. Optional.
    public let description: String?

    /// A dictionary of properties with their own schemas.
    public let properties: [String: LexiconDefinition]

    /// An array of properties that are required in the lexicon. Optional.
    public let required: [String]?

    /// An array of properties that can be receive the value of `nil`. Optional.
    public let nullable: [String]?

    /// Creates an instance of `ATObjectType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional. Defaults to `nil`.
    ///   - properties: A dictionary of properties with their own schemas.
    ///   - required: An array of properties that are required in the lexicon. Optional. Defaults to `nil`.
    ///   - nullable: An array of properties that can be receive the value of `nil`. Optional.
    ///   Defaults to `nil`.
    public init(description: String? = nil, properties: [String : LexiconDefinition], required: [String]? = nil, nullable: [String]? = nil) {
        self.description = description
        self.properties = properties
        self.required = required
        self.nullable = nullable
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.properties = try container.decode([String : LexiconDefinition].self, forKey: .properties)
        self.required = try container.decodeIfPresent([String].self, forKey: .required)
        self.nullable = try container.decodeIfPresent([String].self, forKey: .nullable)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.properties, forKey: .properties)
        try container.encodeIfPresent(self.required, forKey: .required)
        try container.encodeIfPresent(self.nullable, forKey: .nullable)
    }

    enum CodingKeys: CodingKey {
        case description
        case properties
        case required
        case nullable
    }
}
