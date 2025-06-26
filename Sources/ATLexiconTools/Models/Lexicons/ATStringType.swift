//
//  ATStringType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//


/// A `string` type.
///
/// In Swift, this would be the equivalent to the `String` type.
public struct ATStringType: Codable {

    /// The type value of the object.
    ///
    /// This will always be `string`.
    public var type: String { "string" }

    /// A short description of the object. Optional.
    public let description: String?

    /// The string format restriction. Optional.
    public let format: Format?

    /// The maximum number of characters allowed in the field. Optional.
    public let maximumLength: Int?

    /// The minimum number of characters allowed in the field. Optional.
    public let minimumLength: Int?

    /// The maximum number of grapheme characters in the field. Optional.
    public let maximumGraphemes: Int?

    /// The minimum number of grapheme characters in the field. Optional.
    public let minimumGraphemes: Int?

    /// Suggested or common values for this field. Optional.
    public let knownValues: [String]?

    /// A closed set of allowed values. Optional.
    public let enumValues: [String]?

    /// The default value for this field. Optional.
    public let defaultValue: String?

    /// A fixed value for the object. Optional.
    public let constantValue: String?

    enum CodingKeys: String, CodingKey {
        case description
        case format
        case maximumLength = "maxLength"
        case minimumLength = "minLength"
        case maximumGraphemes = "maxGraphemes"
        case minimumGraphemes = "minGraphemes"
        case knownValues
        case enumValues = "enum"
        case defaultValue = "default"
        case constantValue = "const"
    }

    /// The string format restriction.
    public enum Format: String, Codable {

        /// Indicates the format is either a decentralized identifier (DID) or
        /// user account handle.
        case atIdentifier = "at-identifier"

        /// Indicates the format is an AT Identifier.
        case atURI = "at-uri"

        /// Indicates the format is a CID hash.
        case cid

        /// Indicates the format is an ISO-formatted date and time.
        case dateTime = "datetime"

        /// Indicates the format is a decentralized identifier (DID).
        case did

        /// Indicates the format is a user account handle.
        case handle

        /// Indicates the format is a Namespaced Identifier (NSID).
        case nsid

        /// Indicates the format is a Timestamp Identifier.
        case tid

        /// Indicates the format is a Record Key.
        case recordKey = "record-key"

        /// Indicates the format is a URI.
        case uri

        /// Indicates the format is a language code.
        case language
    }
}