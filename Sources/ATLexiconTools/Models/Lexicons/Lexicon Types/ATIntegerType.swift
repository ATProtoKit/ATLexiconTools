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
    public let constantValue: Int?

    /// Creates an instance of `ATIntegerType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional.
    ///   - minimum: The minimum number. Optional.
    ///   - maximum: The maximum number. Optional.
    ///   - enumValues: An array of allowed values. Optional.
    ///   - defaultValue: A default value for the field. Optional.
    ///   - constantValue: A fixed value for the field. Optional.
    public init(description: String?, minimum: Int?, maximum: Int?, enumValues: [Int]?, defaultValue: Int?, constantValue: Int?) throws {
        self.description = description
        self.minimum = minimum
        self.maximum = maximum
        self.enumValues = enumValues
        self.defaultValue = defaultValue
        self.constantValue = constantValue
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.minimum = try container.decodeIfPresent(Int.self, forKey: .minimum)
        self.maximum = try container.decodeIfPresent(Int.self, forKey: .maximum)
        self.enumValues = try container.decodeIfPresent([Int].self, forKey: .enumValues)
        self.defaultValue = try container.decodeIfPresent(Int.self, forKey: .defaultValue)
        self.constantValue = try container.decodeIfPresent(Int.self, forKey: .constantValue)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.minimum, forKey: .minimum)
        try container.encodeIfPresent(self.maximum, forKey: .maximum)
        try container.encodeIfPresent(self.enumValues, forKey: .enumValues)
        try container.encodeIfPresent(self.defaultValue, forKey: .defaultValue)
        try container.encodeIfPresent(self.constantValue, forKey: .constantValue)
    }

    enum CodingKeys: String, CodingKey {
        case description
        case minimum
        case maximum
        case enumValues = "enum"
        case defaultValue = "default"
        case constantValue = "const"
    }

    // Validators
    /// Validates a lexicon integer definition.
    ///
    /// - Parameters:
    ///   - minimum: The minimum number. Optional.
    ///   - maximum: The maximum number. Optional.
    ///   - enumValues: An array of allowed values. Optional.
    ///   - defaultValue: A default value for the field. Optional.
    ///   - constant: A fixed value for the field. Optional.
    public static func validate(minimum: Int?, maximum: Int?, enumValues: [Int]?, defaultValue: Int?, constant: Int?) throws {

        // Minimum and Maximum
        if let constant = constant {
            if let maximum = maximum {
                try LexiconToolsUtilities.require(
                    constant <= maximum,
                    or: .intConstantGreaterThanMaximum(constant: constant, maximumLength: maximum)
                )
            }

            if let minimum = minimum {
                try LexiconToolsUtilities.require(
                    constant >= minimum,
                    or: .intConstantLessThanMinimum(constant: constant, minimumLength: minimum)
                )
            }
        }

        if let defaultValue = defaultValue {
            if let maximum = maximum {
                try LexiconToolsUtilities.require(
                    defaultValue <= maximum,
                    or: .intDefaultValueGreaterThanMaximum(defaultValue: defaultValue, maximumLength: maximum)
                )
            }
            
            if let minimum = minimum {
                try LexiconToolsUtilities.require(
                    defaultValue >= minimum,
                    or: .intDefaultValueLessThanMinimum(defaultValue: defaultValue, minimumLength: minimum)
                )
            }
        }

        // enumValues
        if let values = enumValues, !values.isEmpty,
           let minimum, let maximum,
           let outOfRange = values.first(where: { $0 < minimum || $0 > maximum })
        {
            throw LexiconValidatorError.intEnumValueOutsideRange(
                enumValue: outOfRange,
                minimumValue: minimum,
                maximumValue: maximum
            )
        }
    }
}
