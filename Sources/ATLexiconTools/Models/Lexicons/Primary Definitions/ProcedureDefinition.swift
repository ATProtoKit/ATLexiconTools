//
//  ProcedureDefinition.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A primary `procedure` type definition.
public struct ProcedureDefinition: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `procedure`.
    public var type: String = "procedure"

    /// A short description explaining the definition. Optional.
    public let description: String?

    /// A dictionary of query parameters for the HTTP request. Optional.
    public let parameters: [String: ATParamsType]?

    /// The body that is returned from the server as a result of the request. Optional.
    public let output: LexiconHTTPBody?

    /// The request body that is sent to the server. Optional.
    public let input: LexiconHTTPBody?

    /// An array of errors that might be returned. Optional.
    public let errors: [ATErrorsType]?
}
