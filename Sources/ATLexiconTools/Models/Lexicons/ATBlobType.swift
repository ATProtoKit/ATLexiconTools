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
public struct ATBlobType: Codable {

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

    enum CodingKeys: String, CodingKey {
        case description
        case accept
        case maximumSize = "maxSize"
    }
}
