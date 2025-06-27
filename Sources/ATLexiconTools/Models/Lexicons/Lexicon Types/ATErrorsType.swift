//
//  ATErrorsType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// An error definition.
public struct ATErrorsType: Codable {

    /// The type value of the object.
    ///
    /// It should be short and with no whitespaces.
    public let name: String

    /// A short description about the error. Optional.
    public let description: String?
}
