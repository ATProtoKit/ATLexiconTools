//
//  QueryDefinition.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A primary `query` type definition.
public struct QueryDefinition: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `query`.
    public var type: String = "query"

    /// A short description explaining the definition. Optional.
    public let description: String?

    /// A dictionary of query parameters for the HTTP request. Optional.
    public let parameters: ATParamsType?

    /// The body that is returned from the server as a result of the request. Optional.
    public let output: LexiconHTTPBody?

    /// An array of errors that might be returned. Optional.
    public let errors: [ATErrorsType]?
}
