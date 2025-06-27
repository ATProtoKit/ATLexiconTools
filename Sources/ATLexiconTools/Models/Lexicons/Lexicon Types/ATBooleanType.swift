//
//  ATBooleanType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `boolean` type.
///
/// In Swift, this would be the equivalent to the `Bool` type.
public struct ATBooleanType: Codable {

    /// The type value of the object.
    ///
    /// This will always be `boolean`.
    public var type: String { "boolean" }

    /// A short description of the object. Optional.
    public let description: String?

    /// A default value for the field. Optional.
    public let defaultValue: Bool?

    /// A fixed value for the field. Optional.
    public let constant: Bool?

    enum CodingKeys: String, CodingKey {
        case description
        case defaultValue = "default"
        case constant = "const"
    }
}
