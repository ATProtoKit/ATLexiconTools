//
//  ATErrorsType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// An error definition.
public struct ATErrorsType: Codable, Sendable {

    /// The type value of the object.
    ///
    /// It should be short and with no whitespaces.
    public let name: String

    /// A short description about the error. Optional.
    public let description: String?

    /// Creates an instance of `ATErrorsType`.
    ///
    /// - Parameters:
    ///   - name: The type value of the object.
    ///   - description: A short description about the error. Optional. Defaults to `nil`.
    public init(name: String, description: String? = nil) {
        self.name = name
        self.description = description
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.description, forKey: .description)
    }

    enum CodingKeys: CodingKey {
        case name
        case description
    }
}
