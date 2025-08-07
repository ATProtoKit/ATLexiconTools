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

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}
