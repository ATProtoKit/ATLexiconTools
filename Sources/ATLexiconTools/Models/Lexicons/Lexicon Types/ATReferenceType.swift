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

    enum CodingKeys: String, CodingKey {
        case description
        case reference = "ref"
    }
}
