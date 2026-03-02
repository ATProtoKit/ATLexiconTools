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

    /// An enumeration referencing a specific property.
    public enum Property: Codable, Sendable {

        /// A `boolean` property.
        case boolean(ATBooleanType)

        /// A `integer` property.
        case integer(ATIntegerType)

        /// A `string` property.
        case string(ATStringType)

        /// An `unknown` property.
        case unknown(ATUnknownType)

        /// A `bytes` property.
        case bytes(ATBytesType)

        /// A `cid-link` property.
        case cidLink(ATCIDLinkType)

        /// A `ref` property.
        case reference(ATReferenceType)

        /// A `union` property.
        case union(ATUnionType)

        /// A `blob` property.
        case blob(ATBlobType)

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)

            switch type {
                case "boolean":
                    self = .boolean(try ATBooleanType(from: decoder))
                case "integer":
                    self = .integer(try ATIntegerType(from: decoder))
                case "string":
                    self = .string(try ATStringType(from: decoder))
                case "unknown":
                    self = .unknown(try ATUnknownType(from: decoder))
                case "bytes":
                    self = .bytes(try ATBytesType(from: decoder))
                case "cid-link":
                    self = .cidLink(try ATCIDLinkType(from: decoder))
                case "ref":
                    self = .reference(try ATReferenceType(from: decoder))
                case "union":
                    self = .union(try ATUnionType(from: decoder))
                case "blob":
                    self = .blob(try ATBlobType(from: decoder))
                default:
                    throw DecodingError.dataCorrupted(
                        .init(
                            codingPath: decoder.codingPath,
                            debugDescription: "Unsupported item: \(type)."
                        )
                    )
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .boolean(let value):
                    try container.encode(value)
                case .integer(let value):
                    try container.encode(value)
                case .string(let value):
                    try container.encode(value)
                case .unknown(let value):
                    try container.encode(value)
                case .bytes(let value):
                    try container.encode(value)
                case .cidLink(let value):
                    try container.encode(value)
                case .reference(let value):
                    try container.encode(value)
                case .union(let value):
                    try container.encode(value)
                case .blob(let value):
                    try container.encode(value)
            }
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
        }
    }
}
