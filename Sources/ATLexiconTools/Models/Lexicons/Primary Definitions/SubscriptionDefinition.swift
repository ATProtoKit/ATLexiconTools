//
//  SubscriptionDefinition.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A primary `subscription` type definition.
public struct SubscriptionDefinition: Codable {

    /// The type value of the object.
    ///
    /// This will always be `subscription`.
    public var type: String = "subscription"

    /// A short description explaining the definition. Optional.
    public let description: String?

    /// A dictionary of parameters.
    public let parameters: ATParamsType?

    /// Specifices what messages can be sent.
    public let message: ATLexiconSubscriptionMessage?

    /// An array of errors.
    public let errors: [ATErrorsType]?
}
