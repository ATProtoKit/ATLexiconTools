//
//  ATLexiconSubscriptionMessage.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// Specifices what messages in a subscription can be sent
public struct ATLexiconSubscriptionMessage: Codable, Sendable {

    /// A short description of the object. Optional.
    public let description: String?

    /// An array of union objects related to the schema for the WebSocket event.
    public let schema: Schema?

    /// An array of union objects related to the schema for the WebSocket event.
    public enum Schema: Codable, Sendable {

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
