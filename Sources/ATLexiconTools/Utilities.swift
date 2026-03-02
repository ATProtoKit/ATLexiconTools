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

    /// Determines whether the runtime value is an object primitive.
    ///
    /// - Parameter value: The primitive value to inspect.
    /// - Returns: `true` if the value is an object value, or `false` if not.
    public static func isObject(_ value: PrimitiveValue) -> Bool {
        if case .dictionary = value {
            return true
        }

        return false
    }

    /// Determines whether a dictionary has a specific key.
    ///
    /// - Parameters:
    ///   - dictionary: Dictionary to inspect.
    ///   - property: The key to check.
    /// - Returns: `true` if the key exists, or `false` if not.
    public static func hasProperty(_ dictionary: [String: PrimitiveValue], property: String) -> Bool {
        dictionary[property] != nil
    }

    /// Determines whether the runtime value has a string `$type` field.
    ///
    ///
    /// - Parameter value: The primitive value to inspect.
    /// - Returns: `true` if a string `$type` field is present, or `false` if it's not.
    public static func isDiscriminatedObject(_ value: PrimitiveValue) -> Bool {
        guard case .dictionary(let dictionary) = value,
              case .string(let type)? = dictionary["$type"] else {
            return false
        }

        return !type.isEmpty
    }

    /// Checks whether a list of lexicon reference URIs contains a given type.
    ///
    /// - Parameters:
    ///   - references: An array of lexicon reference URIs to search.
    ///   - type: A type identifier that will be converted to a lexicon URI.
    /// - Returns: `true` if the normalized type is found in `ref`,
    /// or `false` if not.
    ///
    /// - Throws: An error if the provided `type` cannot be converted to a valid lexicon URI.
    internal static func refencesContainType(references: [String], type: String) throws -> Bool {
        let lexiconURI = try Self.toLexiconURI(from: type)

        if references.contains(lexiconURI) {
            return true
        }

        if lexiconURI.hasSuffix("#main") {
            return references.contains(lexiconURI.replacingOccurrences(of: "#main", with: ""))
        }

        return references.contains("\(lexiconURI)#main")
    }

    /// Converts a polymorphic or protocol-oriented type representation into one or more concrete Swift
    /// types, using the supplied lexicon sources and an optional definition context to resolve symbols.
    ///
    /// - Parameters:
    ///   - lexicons: An ordered collection of type lexicons or symbol tables used to resolve names
    ///   and aliases.
    ///   - definition: A definition that provides additional symbol resolution, generic bindings, or
    ///   visibility rules.
    /// - Returns: An array of concrete type descriptors representing the best-known concrete forms of
    /// the input.
    ///
    /// - Throws: An error if the resolution fails.
    internal static func toConcreteTypes(lexicons: LexiconRegistry, definition: LexiconDefinition) throws -> [LexiconDefinition] {
        switch definition {
            case .reference(let reference):
                return [try lexicons.getDefinition(by: reference.reference)]

            case .union(let unionReference):
                return try unionReference.references.map { ref in
                    try lexicons.getDefinition(by: ref)
                }

            default:
                return [definition]
        }
    }

    /// Enforces a preconditioned requirement check.
    ///
    /// This is a shorthanded version of writing several if statements to make the code easier to read.
    ///
    /// Example:
    /// ```swift
    /// LexiconToolsUtilities.try Self.require(
    ///     value <= max, or: .intDefaultValueGreaterThanMaximum(
    ///         defaultValue: value,
    ///         maximumLength: max
    /// ))
    @inline(__always)
    public static func require(_ condition: @autoclosure () -> Bool,
                                or error: @autoclosure () -> LexiconValidatorError) throws {
        // If the condition fails, throw the lazily-built error
        guard condition() else {
            throw error()
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

