//
//  ATTokenType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `token` type.
///
/// In Swift, this would be the equivalent to an `enum` `case`.
public struct ATTokenType: Codable {

    /// The type value of the object.
    ///
    /// This will always be `token`.
    public var type: String { "token" }

    /// A short description of the object. Optional.
    public let description: String?
}
