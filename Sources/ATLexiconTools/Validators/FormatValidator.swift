//
//  FormatValidator.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-08-07.
//

import Foundation
import ATSyntaxTools
import MultiformatsKit

extension Validator.Format {

    /// Validates the date and time that's consistent to the AT Protocol's requirements.
    ///
    /// - Parameters:
    ///   - path: The object this datetime is coming from.
    ///   - dateTimeValue: The actual datetime value.
    ///
    /// - Throws: An error if the date and time are not conforming to the AT Protocol specifications.
    public static func validateDateTime(path: String, dateTimeValue: String) throws {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",        // preferred
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSSSXXXXX", // supported
            "yyyy-MM-dd'T'HH:mm:ssXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SXXXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        ]

        let dateFormatters = formats.map { format -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }

        // Try parsing with each formatter
        for formatter in dateFormatters {
            if formatter.date(from: dateTimeValue) != nil {
                return
            }
        }

        throw LexiconValidatorError.notAValidDateTime(path: path)
    }

    /// Validates the URI that's consistent to the AT Protocol's requirements.
    ///
    /// - Parameters:
    ///  - path: The object this URI is coming from.
    ///  - uriValue: The actual URI value.
    ///
    /// - Throws: An error if the URI are not conforming to the AT Protocol specifications.
    public static func validateURI(path: String, uriValue: String) throws {
        let uriRegex = try NSRegularExpression(pattern: #"^\w+:(?:\/\/)?[^\s/][^\s]*$"#)
        let range = NSRange(uriValue.startIndex..<uriValue.endIndex, in: uriValue)

        guard uriRegex.firstMatch(in: uriValue, options: [], range: range) != nil else {
            throw LexiconValidatorError.notAValidATURI(path: path)
        }
    }

    /// Validates the URI that's consistent to the AT Protocol's requirements.
    ///
    /// - Parameters:
    ///  - path: The object this AT URI is coming from.
    ///  - atURIValue: The actual AT URI value.
    ///
    /// - Throws: An error if the AT URI are not conforming to the AT Protocol specifications.
    public static func validateATURI(path: String, atURIValue: String) throws {
        guard ATURIValidator.isValid(atURIValue) == true else {
            throw LexiconValidatorError.notAValidURI(path: path)
        }
    }

    /// Validates the decentralized identifier (DID) that's consistent to the AT Protocol's requirements.
    ///
    /// - Parameters:
    ///  - path: The object this decentralized identifier (DID) is coming from.
    ///  - didValue: The actual decentralized identifier (DID) value.
    ///
    /// - Throws: An error if the decentralized identifier (DID) is not conforming to the
    /// AT Protocol specifications.
    public static func validateDID(path: String, didValue: String) throws {
        guard DIDValidator.isValid(didValue) == true else {
            throw LexiconValidatorError.notAValidDID(path: path)
        }
    }

    /// Validates the handle that's consistent to the AT Protocol's requirements.
    ///
    /// - Parameters:
    ///   - path: The object the handle is coming from.
    ///   - handleValue: The actual handle value.
    /// - Returns: A valid value.
    ///
    /// - Throws: An error if the handle is not conforming to the AT Protocol specifications.
    public static func validateHandle(path: String, handleValue: String) throws {
        guard HandleValidator.isValid(handleValue) == true else {
            throw LexiconValidatorError.notAValidHandle(path: path)
        }
    }

    /// Validates the AT Identifier that's consistent to the AT Protocol's requirements.
    ///
    /// - Parameters:
    ///   - path: The object the AT Identifier is coming from.
    ///   - atIdentifier: The actual AT Identifier value.
    ///
    /// - Throws: An error if the AT Identifier is not conforming to the AT Protocol specifications.
    public static func validateATIdentifier(path: String, atIdentifier: String) throws {
        if atIdentifier.starts(with: "did:") {
            try validateDID(path: path, didValue: atIdentifier)
            return
        }

        do {
            try validateHandle(path: path, handleValue: atIdentifier)
            return
        } catch {
            throw LexiconValidatorError.notAValidATIdentifier(path: path)
        }
    }

    /// Validates the Namespaced Identifier (NSID) that's consistent to the
    /// AT Protocol specifications.
    ///
    /// - Parameters:
    ///   - path: The object the Namespaced Identifier (NSID) is coming from.
    ///   - nsidValue: The actual Namespaced Identifier (NSID) value.
    ///
    /// - Throws: An error if the Namespaced Identifier (NSID) is not conforming to the
    /// AT Protocol specifications.
    public static func validateNSID(path: String, nsidValue: String) throws {
        guard NSIDValidator.isValid(nsidValue) == true else {
            throw LexiconValidatorError.notAValidHandle(path: path)
        }
    }

    /// Validates the `CID` that's consistent to the AT Protocol specifications.
    ///
    /// - Parameters:
    ///   - path: The object the `CID` is coming from.
    ///   - cidValue: The actual `CID` value.
    ///
    /// - Throws: An error if the `CID` is not conforming to the AT Protocol specifications.
    public static func validateCID(path: String, cidValue: String) throws {
        do {
            _ = try CID(string: cidValue)
            return
        } catch {
            throw error
        }
    }

    /// Validates the BCP 47 language tag that's consistent to the AT Protocol specifications.
    ///
    /// - Parameters:
    ///   - path: The object the BCP 47 language tag is coming from.
    ///   - languageValue: The actual BCP 47 language tag value.
    ///
    /// - Throws: An error if the BCP 47 language tag is not conforming to the AT Protocol specifications.
    public static func validateLanguage(path: String, languageValue: String) throws {
        let regex = #"""
^((?P<grandfathered>(en-GB-oed|i-ami|i-bnn|i-default|i-enochian|i-hak|i-klingon|i-lux|i-mingo|i-navajo|i-pwn|i-tao|i-tay|i-tsu|sgn-BE-FR|sgn-BE-NL|sgn-CH-DE)|(art-lojban|cel-gaulish|no-bok|no-nyn|zh-guoyu|zh-hakka|zh-min|zh-min-nan|zh-xiang))|((?P<language>([A-Za-z]{2,3}(-(?P<extlang>[A-Za-z]{3}(-[A-Za-z]{3}){0,2}))?)|[A-Za-z]{4}|[A-Za-z]{5,8})(-(?P<script>[A-Za-z]{4}))?(-(?P<region>[A-Za-z]{2}|[0-9]{3}))?(-(?P<variant>[A-Za-z0-9]{5,8}|[0-9][A-Za-z0-9]{3}))*(-(?P<extension>[0-9A-WY-Za-wy-z](-[A-Za-z0-9]{2,8})+))*(-(?P<privateUseA>x(-[A-Za-z0-9]{1,8})+))?)|(?P<privateUseB>x(-[A-Za-z0-9]{1,8})+))$
"""#

        let languageRegex = try NSRegularExpression(pattern: regex)
        let range = NSRange(languageValue.startIndex..<languageValue.endIndex, in: languageValue)

        guard languageRegex.firstMatch(in: languageValue, options: [], range: range) != nil else {
            throw LexiconValidatorError.notAValidATURI(path: path)
        }
    }

    /// Validates the Timestamp Identifier (TID) that's consistent to the AT Protocol specifications.
    ///
    /// - Parameters:
    ///   - path: The object the Timestamp Identifier (TID) is coming from.
    ///   - tidValue: The actual Timestamp Identifier (TID) value.
    ///
    /// - Throws: An error if the Timestamp Identifier (TID) is not conforming to the AT Protocol specifications.
    public static func validateTID(path: String, tidValue: String) throws {
        guard TIDValidator.isValid(tidValue) == true else {
            throw LexiconValidatorError.notAValidTID(path: path)
        }
    }

    /// Validates the Record Key that's consistent to the AT Protocol specifications.
    ///
    /// - Parameters:
    ///   - path: The object the Record Key is coming from.
    ///   - recordKeyValue: The actual Record Key value.
    ///
    /// - Throws: An error if the Record Key is not conforming to the AT Protocol specifications.
    public static func validateRecordKey(path: String, recordKeyValue: String) throws {
        guard RecordKeyValidator.isValid(recordKeyValue) == true else {
            throw LexiconValidatorError.notAValidRecordKey(path: path)
        }
    }
}
