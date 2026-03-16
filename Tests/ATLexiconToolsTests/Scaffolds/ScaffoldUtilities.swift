//
//  ScaffoldUtilities.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-03-12.
//

import Foundation
import Testing
import MultiformatsKit
@testable import ATLexiconTools

public func makeLexicons() throws -> LexiconRegistry {
    return try LexiconRegistry(lexicons: generateLexiconScaffolds())
}
