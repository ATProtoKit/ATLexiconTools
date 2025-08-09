//
//  ATIntegerType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `integer` type.
///
/// In Swift, this would be the equivalent to the `Int` type.
public struct ATIntegerType: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `integer`.
    public var type: String { "integer" }

    /// A short description of the object. Optional.
    public let description: String?

    /// The minimum number. Optional.
    public let minimum: Int?

    /// The maximum number. Optional.
    public let maximum: Int?

    /// A closed set of allowed values. Optional.
    public let enumValue: [Int]?

    /// A default value for the field. Optional.
    public let defaultValue: Int?

    /// A fixed value for the field. Optional.
    public let constant: Int?

    enum CodingKeys: String, CodingKey {
        case description
        case minimum
        case maximum
        case enumValue = "enum"
        case defaultValue = "default"
        case constant = "const"
    }
}
