//
//  ATBytesType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `bytes` type.
public struct ATBytesType: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `bytes`.
    public var type: String { "bytes" }

    /// A short description of the object. Optional.
    public let description: String?

    /// The minimum size of un-encoded raw bytes. Optional.
    public let minimumLength: Int?

    /// The maximum size of un-encoded raw bytes. Optional.
    public let maximumLength: Int?

    /// Creates an instance of `ATBytesType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional. Defaults to `nil`.
    ///   - minimumLength: The minimum size of un-encoded raw bytes. Optional. Defaults to `nil`.
    ///   - maximumLength: The maximum size of un-encoded raw bytes. Optional. Defaults to `nil`.
    public init(description: String?, minimumLength: Int?, maximumLength: Int?) {
        self.description = description
        self.minimumLength = minimumLength
        self.maximumLength = maximumLength
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.minimumLength = try container.decodeIfPresent(Int.self, forKey: .minimumLength)
        self.maximumLength = try container.decodeIfPresent(Int.self, forKey: .maximumLength)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.minimumLength, forKey: .minimumLength)
        try container.encodeIfPresent(self.maximumLength, forKey: .maximumLength)
    }

    enum CodingKeys: String, CodingKey {
        case description
        case minimumLength = "minLength"
        case maximumLength = "maxLength"
    }
}
