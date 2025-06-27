//
//  RecordDefinition.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A primary `record` type definition.
public struct RecordDefinition: Codable {

    /// The type value of the object.
    ///
    /// This will always be `record`.
    public var type: String = "record"

    /// A short description explaining the definition. Optional.
    public let description: String?

    /// Specifies the Record Key type.
    public let key: RecordKeyType

    /// A schema definition, which specifies this type of record.
    public let record: ATObjectType

    /// A key that ames and references an individual record within a collection of an
    /// AT Protocol repository.
    public enum RecordKeyType: String, Codable {

        /// Indicates the Record Key type is in the Timespaced Identifier (TID) format.
        case tid

        /// Indicates the Record Key type is in the Namespaced Identifier (NSID) format.
        case nsid

        /// Indicates the Record Key type is a literal format.
        case literalSelf = "literal:self"

        /// Indicates the Record Key type could be any format.
        case any
    }
}
