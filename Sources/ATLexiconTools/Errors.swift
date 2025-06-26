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

    public var errorDescription: String? {
        switch self {
            case .multipleHashSegmentsInURI:
                return "URI can only contain one hash segment."
            case .uriResolutionFailedDueToLackOfAnchor(let anchor):
                return "Unable to resolve URI without anchor: \(anchor)."
        }
    }

    public var description: String {
        return errorDescription ?? String(describing: self)
    }
}
