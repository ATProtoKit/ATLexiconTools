//
//  ATPrimitiveArray.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// An `array` type that contain item primitives.
public struct ATPrimitiveArray: Codable, Sendable {

    /// The type value of the object.
    ///
    /// This will always be `array`.
    public var type: String { "array" }

    /// A short description of the object. Optional.
    public let description: String?

    /// A container of an array of properties.
    public let items: ATLexiconPrimitive?

    /// The minimum length a `string` object can have. Optional.
    public let minimumLength: Int?

    /// The maximum length a `string` object can have. Optional.
    public let maximumLength: Int?

    enum CodingKeys: String, CodingKey {
        case description
        case items
        case minimumLength = "minSize"
        case maximumLength = "maxSize"
    }
}
