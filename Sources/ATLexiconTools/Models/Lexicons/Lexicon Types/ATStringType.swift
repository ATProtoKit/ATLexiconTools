//
//  ATStringType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//


/// A `string` type.
///
/// In Swift, this would be the equivalent to the `String` type.
public struct ATStringType: ATLexiconObjectProtocol {

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

    /// An array of suggested or common values for this field. Optional.
    public let knownValues: [String]?

    /// An array of allowed values. Optional.
    public let enumValues: [String]?

    /// The default value for this field. Optional.
    public let defaultValue: String?

    /// A fixed value for the object. Optional.
    public let constantValue: String?

    /// Creates an instance of `ATIntegerType`.
    ///
    /// - Parameters:
    ///   - description: A short description of the object. Optional.
    ///   - format: The string format restriction. Optional.
    ///   - maximumLength: The maximum number of characters allowed in the field. Optional.
    ///   - minimumLength: The minimum number of characters allowed in the field. Optional.
    ///   - maximumGraphemes: The maximum number of grapheme characters in the field. Optional.
    ///   - minimumGraphemes: The minimum number of grapheme characters in the field. Optional.
    ///   - knownValues: An array of suggested or common values for this field. Optional.
    ///   - enumValues: An array of allowed values. Optional.
    ///   - defaultValue: The default value for this field. Optional.
    ///   - constantValue: A fixed value for the object. Optional.
    public init(
        description: String?,
        format: Format?,
        maximumLength: Int?,
        minimumLength: Int?,
        maximumGraphemes: Int?,
        minimumGraphemes: Int?,
        knownValues: [String]?,
        enumValues: [String]?,
        defaultValue: String?,
        constantValue: String?
    ) {
        self.description = description
        self.format = format
        self.maximumLength = maximumLength
        self.minimumLength = minimumLength
        self.maximumGraphemes = maximumGraphemes
        self.minimumGraphemes = minimumGraphemes
        self.knownValues = knownValues
        self.enumValues = enumValues
        self.defaultValue = defaultValue
        self.constantValue = constantValue
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.format = try container.decodeIfPresent(Format.self, forKey: .format)
        self.maximumLength = try container.decodeIfPresent(Int.self, forKey: .maximumLength)
        self.minimumLength = try container.decodeIfPresent(Int.self, forKey: .minimumLength)
        self.maximumGraphemes = try container.decodeIfPresent(Int.self, forKey: .maximumGraphemes)
        self.minimumGraphemes = try container.decodeIfPresent(Int.self, forKey: .minimumGraphemes)
        self.knownValues = try container.decodeIfPresent([String].self, forKey: .knownValues)
        self.enumValues = try container.decodeIfPresent([String].self, forKey: .enumValues)
        self.defaultValue = try container.decodeIfPresent(String.self, forKey: .defaultValue)
        self.constantValue = try container.decodeIfPresent(String.self, forKey: .constantValue)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.format, forKey: .format)
        try container.encodeIfPresent(self.maximumLength, forKey: .maximumLength)
        try container.encodeIfPresent(self.minimumLength, forKey: .minimumLength)
        try container.encodeIfPresent(self.maximumGraphemes, forKey: .maximumGraphemes)
        try container.encodeIfPresent(self.minimumGraphemes, forKey: .minimumGraphemes)
        try container.encodeIfPresent(self.knownValues, forKey: .knownValues)
        try container.encodeIfPresent(self.enumValues, forKey: .enumValues)
        try container.encodeIfPresent(self.defaultValue, forKey: .defaultValue)
        try container.encodeIfPresent(self.constantValue, forKey: .constantValue)
    }

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

    /// Validates the string value based on their format.
    private static func validateFormat(format: Format, value: String) throws {
        switch format {
            case .atIdentifier:
                _ = try Validator.Format.validateATIdentifier(path: "", atIdentifier: value)
            case .atURI:
                _ = try Validator.Format.validateATURI(path: "", atURIValue: value)
            case .cid:
                _ = try Validator.Format.validateCID(path: "", cidValue: value)
            case .dateTime:
                _ = try Validator.Format.validateDateTime(path: "", dateTimeValue: value)
            case .did:
                _ = try Validator.Format.validateDID(path: "", didValue: value)
            case .handle:
                _ = try Validator.Format.validateHandle(path: "", handleValue: value)
            case .nsid:
                _ = try Validator.Format.validateNSID(path: "", nsidValue: value)
            case .tid:
                _ = try Validator.Format.validateTID(path: "", tidValue: value)
            case .recordKey:
                _ = try Validator.Format.validateRecordKey(path: "", recordKeyValue: value)
            case .uri:
                _ = try Validator.Format.validateURI(path: "", uriValue: value)
            case .language:
                _ = try Validator.Format.validateLanguage(path: "", languageValue: value)
        }
    }
}
