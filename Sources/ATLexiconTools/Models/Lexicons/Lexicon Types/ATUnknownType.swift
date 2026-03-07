//
//  ATUnknownType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// An `unknown` type.
public struct ATUnknownType: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `unknown`.
    public var type: String { "unknown" }

    /// A short description of the object. Optional.
    public let description: String?

    /// Creates an instance of `ATUnknownType`.
    ///
    /// - Parameter description: A short description of the object. Optional. Defaults to `nil`.
    public init(description: String? = nil) {
        self.description = description
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
    }

    enum CodingKeys: CodingKey {
        case description
    }
}
