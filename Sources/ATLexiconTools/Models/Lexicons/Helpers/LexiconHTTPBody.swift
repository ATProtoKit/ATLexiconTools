//
//  LexiconHTTPBody.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A request and response body typically used for ``QueryDefinition`` and ``ProcedureDefinition``.
public struct LexiconHTTPBody: Codable, Sendable {

    /// A short description about the input or output. Optional.
    public let description: String?

    /// The MIME type for body contents.
    ///
    /// For JSON responses, use `application/json`.
    public let encoding: String

    /// A description of an `object` type. Optional.
    public let schema: ATObjectType?

    /// Creates an instance of `LexiconHTTPBody`.
    ///
    /// - Parameters:
    ///   - description: A short description about the input or output. Optional. Defauts to `nil`.
    ///   - encoding: The MIME type for body contents.
    ///   - schema: A description of an `object` type. Optional. Defaults to `nil`.
    public init(description: String? = nil, encoding: String, schema: ATObjectType? = nil) {
        self.description = description
        self.encoding = encoding
        self.schema = schema
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.encoding = try container.decode(String.self, forKey: .encoding)
        self.schema = try container.decodeIfPresent(ATObjectType.self, forKey: .schema)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encode(self.encoding, forKey: .encoding)
        try container.encodeIfPresent(self.schema, forKey: .schema)
    }

    enum CodingKeys: CodingKey {
        case description
        case encoding
        case schema
    }
}
