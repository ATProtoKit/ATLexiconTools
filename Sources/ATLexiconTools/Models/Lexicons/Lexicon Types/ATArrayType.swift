//
//  ATArrayType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// An `array` type.
///
/// In Swift, this would be the equivalent to the `Array` type.
public struct ATArrayType: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `array`.
    public var type: String { "array" }

    /// A short description of the object. Optional.
    public let description: String?

    /// A container of an array of properties.
    public let items: Item

    /// The minimum length a `string` object can have. Optional.
    public let minimumLength: Int?

    /// The maximum length a `string` object can have. Optional.
    public let maximumLength: Int?

    /// Creates an instance of `ATArrayType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional. Defaults to `nil`.
    ///   - items: A container of an array of properties.
    ///   - minimumLength: The minimum length a `string` object can have. Optional. Defaults to `nil`.
    ///   - maximumLength: The maximum length a `string` object can have. Optional. Defaults to `nil`.
    public init(description: String? = nil, items: Item, minimumLength: Int? = nil, maximumLength: Int? = nil) {
        self.description = description
        self.items = items
        self.minimumLength = minimumLength
        self.maximumLength = maximumLength
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.items = try container.decode(ATArrayType.Item.self, forKey: .items)
        self.minimumLength = try container.decodeIfPresent(Int.self, forKey: .minimumLength)
        self.maximumLength = try container.decodeIfPresent(Int.self, forKey: .maximumLength)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.items, forKey: .items)
        try container.encodeIfPresent(self.minimumLength, forKey: .minimumLength)
        try container.encodeIfPresent(self.maximumLength, forKey: .maximumLength)
    }

    enum CodingKeys: String, CodingKey {
        case description
        case items
        case minimumLength = "minSize"
        case maximumLength = "maxSize"
    }

    /// An enumeration referencing a specific property.
    public enum Item: Codable, Sendable {

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
