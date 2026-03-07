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

    /// Creates an instance of `ProcedureDefinition`.
    ///
    /// - Parameters:
    ///   - description: A short description explaining the definition. Optional. Defaults to `nil`.
    ///   - parameters: A dictionary of query parameters for the HTTP request. Optional. Defaults to `nil`.
    ///   - output: The body that is returned from the server as a result of the request. Optional.
    ///   Defaults to `nil`.
    ///   - input: The request body that is sent to the server. Optional. Defaults to `nil`.
    ///   - errors: An array of errors that might be returned. Optional. Defaults to `nil`.
    public init(description: String? = nil, parameters: [String : ATParamsType]? = nil, output: LexiconHTTPBody? = nil,
                input: LexiconHTTPBody? = nil, errors: [ATErrorsType]? = nil) {
        self.description = description
        self.parameters = parameters
        self.output = output
        self.input = input
        self.errors = errors
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(String.self, forKey: .type)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.parameters = try container.decodeIfPresent([String : ATParamsType].self, forKey: .parameters)
        self.output = try container.decodeIfPresent(LexiconHTTPBody.self, forKey: .output)
        self.input = try container.decodeIfPresent(LexiconHTTPBody.self, forKey: .input)
        self.errors = try container.decodeIfPresent([ATErrorsType].self, forKey: .errors)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.parameters, forKey: .parameters)
        try container.encodeIfPresent(self.output, forKey: .output)
        try container.encodeIfPresent(self.input, forKey: .input)
        try container.encodeIfPresent(self.errors, forKey: .errors)
    }

    public enum CodingKeys: CodingKey {
        case type
        case description
        case parameters
        case output
        case input
        case errors
    }
}
