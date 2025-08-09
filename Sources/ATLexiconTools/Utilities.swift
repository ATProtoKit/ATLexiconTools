//
//  Utilities.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A group of utilities for ATLexiconTools.
public enum LexiconToolsUtilities {

    /// Converts a `String` object to a lexicon URI.
    ///
    /// - Parameters:
    ///   - string: *to be added*
    ///   - baseURI: The URI of the *to be completed*. Optional. Defaults to `nil`.
    /// - Returns: A `String` object
    public static func toLexiconURI(from string: String, resolvedAgainst baseURI: String? = nil) throws -> String {
        guard string.split(separator: "#").count < 2 else {
            throw LexiconToolsError.multipleHashSegmentsInURI
        }

        if string.starts(with: "lex:") {
            return string
        }

        if string.starts(with: "#") {
            guard let baseURI = baseURI else {
                throw LexiconToolsError.uriResolutionFailedDueToLackOfAnchor(anchor: string)
            }

            return "\(baseURI)\(string)"
        }

        return "lex:\(string)"
    }


    /// Validates that all required property keys exist in the properties dictionary.
    ///
    /// - Parameters:
    ///   - object: *to be added*.
    ///   - context: *to be added*.
    public static func validateRequiredProperties<ObjectType: ObjectTypeProtocol>(in object: ObjectType, context: inout RefinementContext) {
        guard let requiredObjects = object.required else { return }

        guard let objectProperties = object.properties else {
            if requiredObjects.count > 0 {
                context.addIssue("Required fields defined but no properties defined.")
            }

            return
        }

        for field in requiredObjects {
            if objectProperties[field] == nil {
                context.addIssue("Required field '\(field)' not defined.")
            }
        }
    }

    ///
    public protocol ObjectTypeProtocol {

        ///
        var required: [String]? { get }

        ///
        var properties: [String: Any]? { get }
    }

    ///
    public struct RefinementContext {

        /// An array of issues.
        public var issues: [String] = []

        /// Adds an issue.
        ///
        /// - Parameter issue: *to be added.*
        public mutating func addIssue(_ issue: String) {
            issues.append(issue)
        }
    }
}

