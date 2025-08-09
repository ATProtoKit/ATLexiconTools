//
//  ATCIDLinkType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A `cid-link` type.
public struct ATCIDLinkType: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `cid-link`.
    public var type: String { "cid-link" }

    /// A short description of the object. Optional.
    public let description: String?
}
