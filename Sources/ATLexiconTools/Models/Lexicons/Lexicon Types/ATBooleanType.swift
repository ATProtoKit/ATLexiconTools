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
public struct ATBooleanType: ATLexiconObjectProtocol {

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

    /// Creates an instance of `ATBooleanType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional.
    ///   - defaultValue: A default value for the field. Optional.
    ///   - constant: A fixed value for the field. Optional.
    public init(description: String?, defaultValue: Bool?, constant: Bool?) {
        self.description = description
        self.defaultValue = defaultValue
        self.constant = constant
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.defaultValue = try container.decodeIfPresent(Bool.self, forKey: .defaultValue)
        self.constant = try container.decodeIfPresent(Bool.self, forKey: .constant)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.defaultValue, forKey: .defaultValue)
        try container.encodeIfPresent(self.constant, forKey: .constant)
    }

    enum CodingKeys: String, CodingKey {
        case description
        case defaultValue = "default"
        case constant = "const"
    }
}
