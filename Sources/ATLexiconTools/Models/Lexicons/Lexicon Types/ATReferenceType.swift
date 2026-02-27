//
//  ATReferenceType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `ref` type.
///
/// In Swift, this would typicaly be the equivalent of assigning a property or `case` to a
/// `struct`, `class`, or `enum`.
public struct ATReferenceType: Codable, Sendable {

    /// The type value of the object.
    ///
    /// This will always be `ref`.
    public var type: String { "ref" }

    /// A short description of the object. Optional.
    public let description: String?

    /// A reference to another part of a lexicon.
    public let reference: String

    /// Creates an instance of `ATReferenceType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional. Defaults to `nil`.
    ///   - reference: A reference to another part of a lexicon.
    public init(description: String? = nil, reference: String) {
        self.description = description
        self.reference = reference
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.reference = try container.decode(String.self, forKey: .reference)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.reference, forKey: .reference)
    }

    enum CodingKeys: String, CodingKey {
        case description
        case reference = "ref"
    }
}
