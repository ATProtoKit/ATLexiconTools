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

    /// A description of an `object` type.
    public let schema: ATObjectType?
}
