//
//  ATParamsType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `params` type.
///
/// In Swift, this would be the equivalent to the `Dictionary` type.
public struct ATParamsType: Codable, Sendable {

    /// The type value of the object.
    ///
    /// This will always be `params`.
    public var type: String { "params" }

    /// A short description of the object. Optional.
    public let description: String?

    /// An array of properties that are required in the lexicon. Optional.
    public let required: [String]?

    /// A dictionary of properties with their own schemas.
    public let properties: [String: Property]

    /// Creates an instance of `ATParamsType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional. Defaults to `nil`.
    ///   - required: An array of properties that are required in the lexicon. Optional. Defaults to `nil`.
    ///   - properties: A dictionary of properties with their own schemas.
    public init(description: String? = nil, required: [String]? = nil, properties: [String : Property]) {
        self.description = description
        self.required = required
        self.properties = properties
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.required = try container.decodeIfPresent([String].self, forKey: .required)
        self.properties = try container.decode([String : ATParamsType.Property].self, forKey: .properties)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.required, forKey: .required)
        try container.encode(self.properties, forKey: .properties)
    }

    enum CodingKeys: CodingKey {
        case description
        case required
        case properties
    }

    /// A specific property.
    public enum Property: Codable, Sendable {

        /// A `boolean` property.
        case boolean(ATBooleanType)

        /// An `integer` property.
        case integer(ATIntegerType)

        /// A `string` property.
        case string(ATStringType)

        /// A `unknown` property.
        case unknown(ATUnknownType)

        /// An `array` of a specific property.
        case array(ATPrimitiveArray)

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
                case "array":
                    self = .array(try ATPrimitiveArray(from: decoder))
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
                case .array(let value):
                    try container.encode(value)
            }
        }

        enum CodingKeys: String, CodingKey {
            case type = "$type"
        }
    }
}
