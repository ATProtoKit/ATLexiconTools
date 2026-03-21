//
//  ATLexiconSubscriptionMessage.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// Specifices what messages in a subscription can be sent
public struct ATLexiconSubscriptionMessage: Codable, Sendable, Equatable {

    /// A short description of the object. Optional.
    public let description: String?

    /// An array of union objects related to the schema for the WebSocket event.
    public let schema: Schema?

    /// Create an instance of `ATLexiconSubscriptionMessage`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional. Defaults to `nil`.
    ///   - schema: An array of union objects related to the schema for the WebSocket event. Optional.
    ///   Defaults to `nil`.
    public init(description: String? = nil, schema: Schema? = nil) {
        self.description = description
        self.schema = schema
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.schema = try container.decodeIfPresent(ATLexiconSubscriptionMessage.Schema.self, forKey: .schema)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.schema, forKey: .schema)
    }

    enum CodingKeys: CodingKey {
        case description
        case schema
    }

    /// An array of union objects related to the schema for the WebSocket event.
    public enum Schema: Codable, Sendable, Equatable {

        /// A group of reference variants.
        case referenceVariant(ATLexiconReferenceVariant)

        /// An `object` type.
        case object(ATObjectType)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let value = try? container.decode(ATLexiconReferenceVariant.self) {
                self = .referenceVariant(value)
            } else if let value = try? container.decode(ATObjectType.self) {
                self = .object(value)
            } else {
                throw DecodingError.typeMismatch(
                    Schema.self,
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Unsupported value in ATLexiconSubscriptionMessage.Schema."))
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
                case .referenceVariant(let value):
                    try container.encode(value)
                case .object(let value):
                    try container.encode(value)
            }
        }
    }
}
