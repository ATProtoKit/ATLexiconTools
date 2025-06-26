//
//  ATLexiconPrimitive.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A group of primitives that might be used in a union.
///
/// - Important: This may be removed in the future.
public enum ATLexiconPrimitive: Codable {

    /// The primitive is a boolean.
    case boolean(ATBooleanType)

    /// The primitive is an integer.
    case integer(ATIntegerType)

    /// The primitive is a string.
    case string(ATStringType)

    /// The primitive is an unknown type.
    case unknown(ATUnknownType)
}
