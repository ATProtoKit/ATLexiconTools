//
//  ATUnknownType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// An `unknown` type.
public struct ATUnknownType: Codable {

    /// The type value of the object.
    ///
    /// This will always be `unknown`.
    public var type: String { "unknown" }

    /// A short description of the object. Optional.
    public let description: String?
}
