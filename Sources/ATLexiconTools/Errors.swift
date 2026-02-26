//
//  Errors.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// Errors that can occur within ATLexiconTools.
public enum LexiconToolsError: Error, LocalizedError, CustomStringConvertible {

    /// The URI contained multiple hash segments.
    case multipleHashSegmentsInURI

    /// The URI resolution failed because it couldn't find a specified anchor.
    ///
    /// - Parameter anchor: The anchor that was expected to be found.
    case uriResolutionFailedDueToLackOfAnchor(anchor: String)

    /// An error occured when attempting to validate a lexicon.
    case validationFailed

    /// The lexicon provided was invalid.
    case invalidLexicon

    /// The definition for the lexicon was not found.
    case lexiconDefinitionNotFound

    public var errorDescription: String? {
        switch self {
            case .multipleHashSegmentsInURI:
                return "URI can only contain one hash segment."
            case .uriResolutionFailedDueToLackOfAnchor(let anchor):
                return "Unable to resolve URI without anchor: \(anchor)."
            case .validationFailed:
                return "Failed to validate lexicon."
            case .invalidLexicon:
                return "The lexicon is invalid."
            case .lexiconDefinitionNotFound:
                return "The lexicon definition was not found."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Errors that can occur with blob reference conversions.
public enum BlobReferenceConversionError: Error, LocalizedError, CustomStringConvertible {

    /// The structure of the blob reference is invalid.
    case invalidStructure

    /// The blob reference provided has a missing or invalid field.
    ///
    /// - Parameter field: The missing or invalid field.
    case missingOrInvalidField(field: String)

    /// The CID is invalid.
    ///
    /// - Parameter cidString: The invalid CID.
    case invalidCID(cidString: String)

    public var errorDescription: String? {
        switch self {
            case .invalidStructure:
                return "The blob reference provided is invalid."
            case .missingOrInvalidField(let field):
                return "The blob reference provided has a missing or invalid field: \(field)."
            case .invalidCID(let cidString):
                return "IThe blob reference provided contains an invalid CID: \(cidString)"
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Errors that can occur during lexicon validation.
public enum LexiconValidatorError: Error, LocalizedError, CustomStringConvertible {

    /// The date and time provided is invalid.
    ///
    /// The date and time must be a valid AT Protocol datetime
    ///
    /// - Parameter path: The object the datetime is coming from.
    case notAValidDateTime(path: String)

    /// The URI provided is invalid.
    ///
    /// - Parameter path: The object the URI is coming from.
    case notAValidURI(path: String)

    /// The AT URI provided is invalid.
    ///
    /// - Parameter path: The object the AT URI is coming from.
    case notAValidATURI(path: String)

    /// The decentralized identifier (DID) provided is invalid.
    ///
    /// - Parameter path: The object the decentralized identifier (DID) is coming from.
    case notAValidDID(path: String)

    /// The handle provided is invalid.
    ///
    /// - Parameter path: The object the handle is coming from.
    case notAValidHandle(path: String)

    /// The AT Identifier provided is invalid.
    ///
    /// - Parameter path: The object the handle is coming from.
    case notAValidATIdentifier(path: String)

    /// The BCP 47 language tag provided is invalid.
    ///
    /// - Parameter path: The object the BCP 47 language tag is coming from.
    case notAValidBCP47LanguageTag(path: String)

    /// The Timestamp Identifier (TID) provided is invalid.
    ///
    /// - Parameter path: The object the Timestamp Identifier (TID) is coming from.
    case notAValidTID(path: String)

    /// The Record Key provided is invalid.
    ///
    /// - Parameter path: The object the Record Key is coming from.
    case notAValidRecordKey(path: String)

    /// The path provided has an invalid type.
    ///
    /// - Parameters:
    ///   - value: The value itself.
    ///   - expectedType: The type that was expected to be used.
    case invalidType(value: String, expectedType: String)

    /// The type of the lexicon is not one of the valid lexicon types.
    ///
    /// - Parameter type: The name of the lexicon type.
    case unexpectedLexiconType(type: String)

    /// The constant integer is greater than the maximum.
    ///
    /// - Parameters:
    ///   - constant: The value's constant.
    ///   - maximumLength: The maximum number that should not exceed.
    case intConstantGreaterThanMaximum(constant: Int, maximumLength: Int)

    /// The constant integer is less than the minimum.
    ///
    /// - Parameters:
    ///   - constant: The value's constant.
    ///   - minimumLength: The minimum number that should be matched or exceeded.
    case intConstantLessThanMinimum(constant: Int, minimumLength: Int)

    /// The default value integer is greater than the maximum.
    ///
    /// - Parameters:
    ///   - defaultValue: The default value.
    ///   - maximumLength: The maximum number that should not exceed.
    case intDefaultValueGreaterThanMaximum(defaultValue: Int, maximumLength: Int)

    /// The default value integer is less than the minimum.
    ///
    /// - Parameters:
    ///   - defaultValue: The default value.
    ///   - maximumLength: The maximum number that should not exceed.
    case intDefaultValueLessThanMinimum(defaultValue: Int, minimumLength: Int)

    /// An enum integer value is either less than the minimum, or greater than the maximum.
    ///
    /// - Parameters:
    ///   - enumValue: The default value.
    ///   - minimumValue: The minimum value to not exceed.
    ///   - maximumValue: The maximum value to not exceed.
    case intEnumValueOutsideRange(enumValue: Int, minimumValue: Int, maximumValue: Int)

    /// The constant string is greater than the maximum length (Unicode scalars).
    ///
    /// - Parameters:
    ///   - constant: The value's constant.
    ///   - maximumLength: The maximum number that should not exceed.
    case stringConstantGreaterThanMaximumLength(constant: String, maximumLength: Int)

    /// The constant string as less than the minimum length (Unicode scalars).
    ///
    /// - Parameters:
    ///   - constant: The value's constant.
    ///   - minimumLength: The minimum number that should be matched or exceeded.
    case stringConstantLessThanMinimumLength(constant: String, minimumLength: Int)

    /// The constant string as less than the maximum graphemes.
    ///
    /// - Parameters:
    ///   - constant: The value's constant.
    ///   - minimumGraphemes: The minimum number that should be matched or exceeded.
    case stringConstantGreaterThanMaximumGraphemes(constant: String, maximumLength: Int)

    /// The constant string as less than the minimum graphemes.
    ///
    /// - Parameters:
    ///   - constant: The value's constant.
    ///   - minimumGraphemes: The minimum number that should be matched or exceeded.
    case stringConstantLessThanMinimumGraphemes(constant: String, maximumLength: Int)

    /// The constant bytes is greater than the maximum length.
    ///
    /// - Parameters:
    ///   - constant: The value's constant.
    ///   - maximumLength: The maximum number that should not exceed.
    case bytesConstantGreaterThankMaximumLength(constant: Data, maximumLength: Int)

    /// The provided path is a an invalid blob reference.
    case invalidBlobReferencePath(path: String)

    public var errorDescription: String? {
        switch self {
            case .notAValidDateTime(let path):
                return "Path ('\(path)') must be a valid AT Protocol datetime (either RFC-3339 or ISO-8601)."
            case .notAValidURI(let path):
                return "Path ('\(path)') must be a valid URI."
            case .notAValidATURI(let path):
                return "Path ('\(path)') must be a valid AT URI."
            case .notAValidDID(let path):
                return "Path ('\(path)') must be a valid DID."
            case .notAValidHandle(path: let path):
                return "Path ('\(path)') must be a valid handle."
            case .notAValidATIdentifier(let path):
                return "Path ('\(path)') must be a valid DID or handle."
            case .notAValidBCP47LanguageTag(let path):
                return "Path ('\(path)') must be a valid BCP 47 language tag."
            case .notAValidTID(let path):
                return "Path ('\(path)') must be a valid Timestamp Identifier (TID)."
            case .notAValidRecordKey(path: let path):
                return "Path ('\(path)') must be a valid Record Key."
            case .invalidType(let value, let expectedType):
                return "Value ('\(value)') must be of type '\(expectedType)'."
            case .unexpectedLexiconType(let type):
                return "Unexpected lexicon type: '\(type)'."
            case .intConstantGreaterThanMaximum(let constant, let maximumLength):
                return "Constant '\(constant)' cannot be greater than the maximum '\(maximumLength)'."
            case .intConstantLessThanMinimum(let constant, let minimumLength):
                return "Constant '\(constant)' cannot be less than the minimum '\(minimumLength)'."
            case .intDefaultValueGreaterThanMaximum(let defaultValue, let maximumLength):
                return "Default value '\(defaultValue)' cannot be greater than the maximum '\(maximumLength)'."
            case .intDefaultValueLessThanMinimum(let defaultValue, let minimumLength):
                return "Default value '\(defaultValue)' cannot be less than the minimum '\(minimumLength)'."
            case .intEnumValueOutsideRange(let enumValue, let minimumValue, let maximumValue):
                return "Enum value '\(enumValue)' must be between '\(minimumValue)' and '\(maximumValue)'."
            case .stringConstantGreaterThanMaximumLength(let constant, let maximumLength):
                return "Constant '\(constant)' cannot be greater than the maximum '\(maximumLength)' Unicode scalar count."
            case .stringConstantLessThanMinimumLength(let constant, let minimumLength):
                return "Constant '\(constant)' cannot be less than the minimum '\(minimumLength)' Unicode scalar count."
            case .stringConstantGreaterThanMaximumGraphemes(let constant, let maximumLength):
                return "Constant '\(constant)' cannot be greater than the maximum '\(maximumLength)' graphme count."
            case .stringConstantLessThanMinimumGraphemes(let constant, let maximumLength):
                return "Constant '\(constant)' cannot be less than the minimum '\(maximumLength)' graphme count."
            case .bytesConstantGreaterThankMaximumLength(constant: let constant, maximumLength: let maximumLength):
                return "Constant '\(constant)' cannot be greater than the maximum '\(maximumLength)' bytes."
            case .invalidBlobReferencePath(let path):
                return "Invalid blob reference path: \(path)"
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}

/// Errors that occur while validating the lexicon schema.
public enum LexiconSchemaValidatorError: Error, LocalizedError, CustomStringConvertible {

    /// The schema provided is invalid.
    ///
    /// - Parameter reason: A string that explains why the schema was invalid.
    case invalidSchema(reason: String)

    public var errorDescription: String? {
        switch self {
            case .invalidSchema(let reason):
                return "Schema validation failed. Reason: \(reason)"
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}
    
/// Errors that occur while interacting with ``LexiconRegistry``.
public enum LexiconRegistryError: Error, LocalizedError, CustomStringConvertible {

    /// The lexicon has already been registered to the `LexiconRegistry` instance.
    ///
    /// - Parameter nsid: The Namespaced Identifier (NSID) associated with the lexion.
    case lexiconAlreadyRegistered(nsid: String)

    /// The lexicon given can't removed since it doesn't exist.
    ///
    /// - Parameter uri: The URI of the lexicon.
    case cannotRemoveLexiconAsItDoesNotExist(uri: String)

    /// The lexicon was not found.
    ///
    /// - Parameter uri: The URI of the lexicon.
    case lexiconNotFound(uri: String)

    /// The lexicon URI provided does not contain the type needed.
    ///
    /// - Parameters:
    ///   - expected: An array of expected types.
    ///   - actual: The type that was actually found.
    ///   - uri: The lexicon's URI.
    case notOfType(expected: [String], actual: String, uri: String)

    /// The type is not a string object.
    case typeIsNotAString

    /// The type provided is invalid.
    ///
    /// - Parameters:
    ///   - expectedValue: The type that's expected to be found.
    ///   - actualValue: The actual type that was found.
    case invalidType(expectedValue: String, actualValue: String)

    public var errorDescription: String? {
        switch self {
            case .lexiconAlreadyRegistered(let nsid):
                return "Lexicon not found for NSID: '\(nsid)'."
            case .cannotRemoveLexiconAsItDoesNotExist(uri: let uri):
                return "Could not remove the lexicon '\(uri)': Lexicon not found."
            case .lexiconNotFound(let uri):
                return "Lexicon not found for URI: '\(uri)'."
            case .notOfType(let expected, let actual, let uri):
                return "Not a \(expected.joined(separator: " or ")) lexicon '\(uri)' (found: \(actual))."
            case .typeIsNotAString:
                return "The type of the lexicon must be a string."
            case .invalidType(let expectedValue, let actualValue):
                return "The type of the lexicon must be '\(expectedValue)', but was '\(actualValue)' instead."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}
