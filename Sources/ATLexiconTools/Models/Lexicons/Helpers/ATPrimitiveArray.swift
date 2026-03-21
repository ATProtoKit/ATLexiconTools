//
//  ATPrimitiveArray.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// An `array` type that contain item primitives.
public struct ATPrimitiveArray: Codable, Sendable, Equatable {

    /// The type value of the object.
    ///
    /// This will always be `array`.
    public var type: String { "array" }

    /// A short description of the object. Optional.
    public let description: String?

    /// A container of an array of properties. Optional.
    public let items: ATLexiconPrimitive?

    /// The minimum length a `string` object can have. Optional.
    public let minimumLength: Int?

    /// The maximum length a `string` object can have. Optional.
    public let maximumLength: Int?

    /// Creates an instance of `ATPrimitiveArray`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional. Defaults to `nil`.
    ///   - items: A container of an array of properties. Optional. Defaults to `nil`.
    ///   - minimumLength: The minimum length a `string` object can have. Optional. Defaults to `nil`.
    ///   - maximumLength: The maximum length a `string` object can have. Optional. Defaults to `nil`.
    public init(description: String? = nil, items: ATLexiconPrimitive? = nil, minimumLength: Int? = nil, maximumLength: Int? = nil) {
        self.description = description
        self.items = items
        self.minimumLength = minimumLength
        self.maximumLength = maximumLength
    }

    enum CodingKeys: String, CodingKey {
        case description
        case items
        case minimumLength = "minSize"
        case maximumLength = "maxSize"
    }
}
