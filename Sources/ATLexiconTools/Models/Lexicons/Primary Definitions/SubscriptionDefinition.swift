//
//  SubscriptionDefinition.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A primary `subscription` type definition.
public struct SubscriptionDefinition: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `subscription`.
    public var type: String = "subscription"

    /// A short description explaining the definition. Optional.
    public let description: String?

    /// A dictionary of parameters. Optional.
    public let parameters: ATParamsType?

    /// Specifices what messages can be sent. Optional.
    public let message: ATLexiconSubscriptionMessage?

    /// An array of errors. Optional.
    public let errors: [ATErrorsType]?

    /// Creates an instance of `SubscriptionDefinition`.
    ///
    /// - Parameters:
    ///   - description: A short description explaining the definition. Optional. Defaults to `nil`.
    ///   - parameters: A dictionary of parameters. Optional. Defaults to `nil`.
    ///   - message: Specifices what messages can be sent. Optional. Defaults to `nil`.
    ///   - errors: An array of errors. Optional. Defaults to `nil`.
    public init(description: String? = nil, parameters: ATParamsType? = nil, message: ATLexiconSubscriptionMessage? = nil,
                errors: [ATErrorsType]? = nil) {
        self.description = description
        self.parameters = parameters
        self.message = message
        self.errors = errors
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(String.self, forKey: .type)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.parameters = try container.decodeIfPresent(ATParamsType.self, forKey: .parameters)
        self.message = try container.decodeIfPresent(ATLexiconSubscriptionMessage.self, forKey: .message)
        self.errors = try container.decodeIfPresent([ATErrorsType].self, forKey: .errors)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.parameters, forKey: .parameters)
        try container.encodeIfPresent(self.message, forKey: .message)
        try container.encodeIfPresent(self.errors, forKey: .errors)
    }

    enum CodingKeys: CodingKey {
        case type
        case description
        case parameters
        case message
        case errors
    }
}
