//
//  ATUnionType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `union` type.
///
/// In Swift, this would be the equivalent to the `Any` type.
public struct ATUnionType: Codable, Sendable {

    /// The type value of the object.
    ///
    /// This will always be `union`.
    public var type: String { "union" }

    /// A short description of the object. Optional.
    public let description: String?

    /// An array of references. Optional.
    public let references: [String]

    /// Indicates whether the union is closed. Optional.
    public var isClosed: Bool?

    /// Creates an instance of `ATUnionType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional. Defaults to `nil`.
    ///   - references: An array of references. Optional. Defaults to `nil`.
    ///   - isClosed: Indicates whether the union is closed. Optional. Defaults to `false`.
    public init(description: String?, references: [String], isClosed: Bool? = false) {
        self.description = description
        self.references = references
        self.isClosed = isClosed
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.references = try container.decode([String].self, forKey: .references)
        self.isClosed = try container.decodeIfPresent(Bool.self, forKey: .isClosed)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.references, forKey: .references)
        try container.encodeIfPresent(self.isClosed, forKey: .isClosed)
    }

    enum CodingKeys: String, CodingKey {
        case description
        case references = "refs"
        case isClosed = "closed"
    }
}
