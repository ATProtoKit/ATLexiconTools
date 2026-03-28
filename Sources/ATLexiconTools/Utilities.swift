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
        guard string.split(separator: "#").count <= 2 else {
            throw LexiconToolsError.multipleHashSegmentsInURI
        }

        if string.hasPrefix("lex:") {
            return string
        }

        if string.hasPrefix("#") {
            guard let baseURI = baseURI else {
                throw LexiconToolsError.uriResolutionFailedDueToLackOfAnchor(anchor: string)
            }

            return "\(baseURI)\(string)"
        }

        return "lex:\(string)"
    }

    /// Determines whether the runtime value is an object primitive.
    ///
    /// - Parameter value: The primitive value to inspect.
    /// - Returns: `true` if the value is an object value, or `false` if not.
    public static func isObject(_ value: PrimitiveValue) -> Bool {
        if case .object = value {
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
        guard case .object(let dictionary) = value,
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

    /// Converts a definition type into one or more concrete Swift types using the provided lexicons.
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
                let resolved = try lexicons.getDefinition(
                    by: self.toLexiconURI(from: reference.reference),
                    shouldNormalizeURI: false
                )

                return [resolved]
            case .union(let unionReference):
                var results: [LexiconDefinition] = []
                guard let references = unionReference.references, !references.isEmpty else {
                    return results
                }

                for reference in references {
                    let resolved = try lexicons.getDefinition(
                        by: self.toLexiconURI(from: reference),
                        shouldNormalizeURI: false
                    )
                    results.append(resolved)
                }

                return results
            default:
                return [definition]
        }
    }

    /// Determines whether the given lexicon definition represents a primitive type that provides a
    /// default value.
    ///
    /// The primitive types that the method will look for are booleans, integers, and strings.
    ///
    /// - Parameter definition: The lexicon definition to inspect.
    ///
    /// - Returns: `true` if the definition type has a non-`nil` default value, or `false` if it doesn't.
    internal static func hasPrimitiveDefault(_ definition: LexiconDefinition) -> Bool {
        switch definition {
            case .boolean(let booleanDefinition):
                return booleanDefinition.defaultValue != nil
            case .integer(let integerDefinition):
                return integerDefinition.defaultValue != nil
            case .string(let stringDefinition):
                return stringDefinition.defaultValue != nil
            default:
                return false
        }
    }

    /// Converts the `LexiconDefinition` value to the corresponding `PrimitiveValue` object.
    ///
    /// The primitive types that the method will look for are booleans, integers, and strings.
    ///
    /// - Parameter definition: The lexicon definition to convert.
    /// - Returns: The converted `PrimitiveValue` object, or `nil` if no value exists.
    internal static func primitiveDefaultValue(for definition: LexiconDefinition) -> PrimitiveValue? {
        switch definition {
            case .boolean(let booleanDefinition):
                guard let defaultValue = booleanDefinition.defaultValue else {
                    return nil
                }

                return .bool(defaultValue)
            case .integer(let integerDefinition):
                guard let defaultValue = integerDefinition.defaultValue else {
                    return nil
                }

                return .int(defaultValue)
            case .string(let stringDefinition):
                guard let defaultValue = stringDefinition.defaultValue else {
                    return nil
                }

                return .string(defaultValue)
            default:
                return nil
        }
    }

    /// Converts a primitive item to a standard lexicon definition.
    ///
    /// - Parameter primitive: The primitive item to convert.
    /// - Returns: The corresponding `LexiconDefinition`.
    internal static func lexiconDefinition(from primitive: ATLexiconPrimitive?) -> LexiconDefinition {
        switch primitive {
            case .boolean(let booleanType):
                return .boolean(booleanType)
            case .integer(let integerType):
                return .integer(integerType)
            case .string(let stringType):
                return .string(stringType)
            case .unknown(let unknownType):
                return .unknown(unknownType)
            case nil:
                return .unknown(ATUnknownType())
        }
    }

    /// Converts a parameters type into an object definition for validation.
    ///
    /// - Parameter parameters: The parameters definition to convert.
    /// - Returns: The converted `ATObjectType` value.
    ///
    /// - Throws: An error if validating the `ATObjectType` object fails.
    internal static func objectDefinition(from parameters: ATParamsType) throws -> ATObjectType {
        let properties = parameters.properties.mapValues { property in
            switch property {
                case .boolean(let booleanType):
                    return LexiconDefinition.boolean(booleanType)
                case .integer(let integerType):
                    return LexiconDefinition.integer(integerType)
                case .string(let stringType):
                    return LexiconDefinition.string(stringType)
                case .unknown(let unknownType):
                    return LexiconDefinition.unknown(unknownType)
                case .array(let arrayType):
                    return .array(
                        ATArrayType(
                            items: self.lexiconDefinition(from: arrayType.items),
                            minimumLength: arrayType.minimumLength,
                            maximumLength: arrayType.maximumLength
                        )
                    )
            }
        }

        return try ATObjectType(
            properties: properties,
            required: parameters.required
        )
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
    internal static func require(_ condition: @autoclosure () -> Bool,
                                or error: @autoclosure () -> LexiconValidatorError) throws {
        // If the condition fails, throw the lazily-built error
        guard condition() else {
            throw error()
        }
    }
}

