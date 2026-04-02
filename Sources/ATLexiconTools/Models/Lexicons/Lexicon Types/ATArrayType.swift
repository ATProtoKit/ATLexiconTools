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
    public let items: LexiconDefinition

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
    public init(description: String? = nil, items: LexiconDefinition, minimumLength: Int? = nil, maximumLength: Int? = nil) {
        self.description = description
        self.items = items
        self.minimumLength = minimumLength
        self.maximumLength = maximumLength
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.items = try container.decode(LexiconDefinition.self, forKey: .items)
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
}
