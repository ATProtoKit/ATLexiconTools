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

    /// Indicates whether the union is closed. Optional. Defaults to `false`.
    public var isClosed: Bool? = false

    enum CodingKeys: String, CodingKey {
        case description
        case references = "refs"
        case isClosed = "closed"
    }
}
