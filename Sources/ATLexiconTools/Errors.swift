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

    // TODO: Complete the Swift implementation of "Validator.validateBlob()".
/////
//    case pathIsNotBlobReference(path: String)

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

    public var errorDescription: String? {
        switch self {
//            case .pathIsNotBlobReference(let path):
//                return "The blob reference provided is invalid."
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
            case .notAValidBCP47LanguageTag(let path):
                return "Path ('\(path)') must be a valid BCP 47 language tag."
            case .notAValidTID(let path):
                return "Path ('\(path)') must be a valid Timestamp Identifier (TID)."
            case .notAValidRecordKey(path: let path):
                return "Path ('\(path)') must be a valid Record Key."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}
