//
//  RecordDefinition.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A primary `record` type definition.
public struct RecordDefinition: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `record`.
    public var type: String = "record"

    /// A short description explaining the definition. Optional.
    public let description: String?

    /// Specifies the Record Key type. Optional.
    public let key: RecordKeyType?

    /// A schema definition, which specifies this type of record.
    public let record: ATObjectType

    /// Creates an instance of `RecordDefinition`.
    ///
    /// - Parameters:
    ///   - description: A short description explaining the definition. Optional. Defaults to `nil`.
    ///   - key: Specifies the Record Key type. Optional. Defaults to `nil`.
    ///   - record: A schema definition, which specifies this type of record.
    public init(description: String? = nil, key: RecordKeyType? = nil, record: ATObjectType) {
        self.description = description
        self.key = key
        self.record = record
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(String.self, forKey: .type)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.key = try container.decodeIfPresent(RecordDefinition.RecordKeyType.self, forKey: .key)
        self.record = try container.decode(ATObjectType.self, forKey: .record)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.key, forKey: .key)
        try container.encode(self.record, forKey: .record)
    }

    enum CodingKeys: CodingKey {
        case type
        case description
        case key
        case record
    }

    /// A key that names and references an individual record within a collection of an
    /// AT Protocol repository.
    public enum RecordKeyType: String, Codable, Sendable {

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
