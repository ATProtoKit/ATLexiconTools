//
//  ATBlobType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `blob` type.
///
/// /// In Swift, this would be the equivalent to the `Data` type.
public struct ATBlobType: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `blob`.
    public var type: String { "blob" }

    /// A short description of the object. Optional.
    public let description: String?

    /// An array of MIME types in a glob pattern (example: `image/jpeg`, `*/*`, etc.). Optional.
    public let accept: [String]?

    /// The maximum size of the blob in bytes. Optional.
    public let maximumSize: Int?

    /// Creates an instance of `ATBlobType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional.
    ///   - accept: An array of MIME types in a glob pattern (example: `image/jpeg`, `*/*`, etc.). Optional.
    ///   - maximumSize: The maximum size of the blob in bytes. Optional.
    public init(description: String?, accept: [String]?, maximumSize: Int?) {
        self.description = description
        self.accept = accept
        self.maximumSize = maximumSize
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.accept = try container.decodeIfPresent([String].self, forKey: .accept)
        self.maximumSize = try container.decodeIfPresent(Int.self, forKey: .maximumSize)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.accept, forKey: .accept)
        try container.encodeIfPresent(self.maximumSize, forKey: .maximumSize)
    }

    enum CodingKeys: String, CodingKey {
        case description
        case accept
        case maximumSize = "maxSize"
    }
}
