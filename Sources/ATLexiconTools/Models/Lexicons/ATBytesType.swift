//
//  ATBytesType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `bytes` type.
public struct ATBytesType: Codable {

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

    enum CodingKeys: String, CodingKey {
        case description
        case minimumLength = "minLength"
        case maximumLength = "maxLength"
    }
}
