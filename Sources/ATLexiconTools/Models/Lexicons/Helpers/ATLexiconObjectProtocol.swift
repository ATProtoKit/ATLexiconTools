//
//  ATLexiconObjectProtocol.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-08-09.
//

/// A protocol representing a lexicon object.
public protocol ATLexiconObjectProtocol: Codable, Sendable, Equatable {

    /// The type value of the lexicon object.
    var type: String { get }
}
