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

    /// An array of allowed values. Optional.
    public let enumValues: [Int]?

    /// A default value for the field. Optional.
    public let defaultValue: Int?

    /// A fixed value for the field. Optional.
    public let constant: Int?

    /// Creates an instance of `ATIntegerType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional.
    ///   - minimum: The minimum number. Optional.
    ///   - maximum: The maximum number. Optional.
    ///   - enumValues: An array of allowed values. Optional.
    ///   - defaultValue: A default value for the field. Optional.
    ///   - constant: A fixed value for the field. Optional.
    public init(description: String?, minimum: Int?, maximum: Int?, enumValues: [Int]?, defaultValue: Int?, constant: Int?) throws {
        self.description = description
        self.minimum = minimum
        self.maximum = maximum
        self.enumValues = enumValues
        self.defaultValue = defaultValue
        self.constant = constant
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.minimum = try container.decodeIfPresent(Int.self, forKey: .minimum)
        self.maximum = try container.decodeIfPresent(Int.self, forKey: .maximum)
        self.enumValues = try container.decodeIfPresent([Int].self, forKey: .enumValues)
        self.defaultValue = try container.decodeIfPresent(Int.self, forKey: .defaultValue)
        self.constant = try container.decodeIfPresent(Int.self, forKey: .constant)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.minimum, forKey: .minimum)
        try container.encodeIfPresent(self.maximum, forKey: .maximum)
        try container.encodeIfPresent(self.enumValues, forKey: .enumValues)
        try container.encodeIfPresent(self.defaultValue, forKey: .defaultValue)
        try container.encodeIfPresent(self.constant, forKey: .constant)
    }

    enum CodingKeys: String, CodingKey {
        case description
        case minimum
        case maximum
        case enumValues = "enum"
        case defaultValue = "default"
        case constant = "const"
    }
}
