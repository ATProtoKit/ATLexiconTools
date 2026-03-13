//
//  PrimitiveValidator.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-08-08.
//

import Foundation
import ATCommonWeb
import MultiformatsKit

extension Validator.Primitive {

    /// Validates the appropriate primitive value.
    ///
    /// - Parameters:
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match the constant value.
    public static func validate(
        path: String,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        switch definition {
            case .boolean(let booleanType):
                try validateBoolean(path: path, definition: booleanType, value: value)
            case .integer(let integerType):
                try validateInteger(path: path, definition: integerType, value: value)
            case .string(let stringType):
                try validateString(path: path, definition: stringType, value: value)
            case .bytes(let bytesType):
                try validateBytes(path: path, definition: bytesType, value: value)
            case .cidLink(let cidLinkType):
                try validateCID(path: path, definition: cidLinkType, value: value)
            case .unknown(let objectType):
                try validateUnknown(path: path, definition: objectType, value: value)
            default:
                throw LexiconValidatorError.unexpectedLexiconType(type: definition.type)
        }

    }

    /// Validates a `Bool` value.
    ///
    /// - Parameters:
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match the constant value.
    private static func validateBoolean(
        path: String,
        definition: ATBooleanType,
        value: PrimitiveValue?
    ) throws {
        guard let value else {
            throw LexiconValidatorError.invalidType(value: path, expectedType: "boolean")
        }

        guard case .bool(let boolValue) = value else {
            throw LexiconValidatorError.invalidType(value: path, expectedType: "boolean")
        }

        if let constantValue = definition.constant, boolValue != constantValue {
            throw LexiconValidatorError.pathIsNotValue(path: path, constantValue: constantValue.description)
        }
    }

    /// Validates an `Int` value.
    ///
    /// - Parameters:
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match an expected value.
    private static func validateInteger(
        path: String,
        definition: ATIntegerType,
        value: PrimitiveValue?
    ) throws {
        guard let value else {
            throw LexiconValidatorError.invalidType(value: path, expectedType: "integer")
        }

        guard case .int(let intValue) = value else {
            throw LexiconValidatorError.invalidType(value: path, expectedType: "integer")
        }

        if let constantValue = definition.constantValue, intValue != constantValue {
            throw LexiconValidatorError.pathIsNotValue(path: path, constantValue: constantValue.description)
        }

        if let enumValues = definition.enumValues, !enumValues.contains(intValue) {
            throw LexiconValidatorError.pathIsNotOneOfSeveralValues(path: path, values: enumValues.map(String.init).joined(separator: ", "))
        }

        if let maximum = definition.maximum, intValue > maximum {
            throw LexiconValidatorError.intConstantGreaterThanMaximum(constant: intValue, path: path, maximumLength: maximum)
        }

        if let minimum = definition.minimum, intValue < minimum {
            throw LexiconValidatorError.intConstantLessThanMinimum(constant: intValue, path: path, minimumLength: minimum)
        }
    }

    /// Validates a `String` value.
    ///
    /// - Parameters:
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match an expected value.
    private static func validateString(
        path: String,
        definition: ATStringType,
        value: PrimitiveValue?
    ) throws {
        guard let value else {
            throw LexiconValidatorError.invalidType(value: path, expectedType: "string")
        }

        guard case .string(let stringValue) = value else {
            throw LexiconValidatorError.invalidType(value: path, expectedType: "string")
        }

        if let constantValue = definition.constantValue, stringValue != constantValue {
            throw LexiconValidatorError.pathIsNotValue(path: path, constantValue: constantValue.description)
        }

        if let enumValues = definition.enumValues, !enumValues.contains(stringValue) {
            throw LexiconValidatorError.pathIsNotOneOfSeveralValues(path: path, values: enumValues.joined(separator: ", "))
        }

        if let maximumLength = definition.maximumLength, stringValue.utf8.count > maximumLength {
            throw LexiconValidatorError.stringValueGreaterThanMaximumLength(value: stringValue, path: path, maximumLength: maximumLength)
        }

        if let minimumLength = definition.minimumLength, stringValue.utf8.count < minimumLength {
            throw LexiconValidatorError.stringValueLessThanMinimumLength(value: stringValue, path: path, minimumLength: minimumLength)
        }

        if let maximumGraphemes = definition.maximumGraphemes, stringValue.count > maximumGraphemes {
            throw LexiconValidatorError.stringValueGreaterThanMaximumGraphemes(value: stringValue, path: path, maximumGraphemes: maximumGraphemes)
        }

        if let minimumGraphemes = definition.minimumGraphemes, stringValue.count < minimumGraphemes {
            throw LexiconValidatorError.stringValueLessThanMinimumGraphemes(value: stringValue, path: path, minimumGraphemes: minimumGraphemes)
        }

        guard let format = definition.format else {
            return
        }

        switch format {
            case .atIdentifier:
                try Validator.Format.validateATIdentifier(path: path, atIdentifier: stringValue)
            case .atURI:
                try Validator.Format.validateATURI(path: path, atURIValue: stringValue)
            case .cid:
                try Validator.Format.validateCID(path: path, cidValue: stringValue)
            case .dateTime:
                try Validator.Format.validateDateTime(path: path, dateTimeValue: stringValue)
            case .did:
                try Validator.Format.validateDID(path: path, didValue: stringValue)
            case .handle:
                try Validator.Format.validateHandle(path: path, handleValue: stringValue)
            case .nsid:
                try Validator.Format.validateNSID(path: path, nsidValue: stringValue)
            case .tid:
                try Validator.Format.validateTID(path: path, tidValue: stringValue)
            case .recordKey:
                try Validator.Format.validateRecordKey(path: path, recordKeyValue: stringValue)
            case .uri:
                try Validator.Format.validateURI(path: path, uriValue: stringValue)
            case .language:
                try Validator.Format.validateLanguage(path: path, languageValue: stringValue)
        }
    }

    /// Validates a bytes value.
    ///
    /// - Parameters:
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match an expected value.
    private static func validateBytes(
        path: String,
        definition: ATBytesType,
        value: PrimitiveValue?
    ) throws {
        guard let value, case .bytes(let dataValue) = value else {
            throw LexiconValidatorError.invalidType(value: path, expectedType: "bytes")
        }

        if let maximumLength = definition.maximumLength, dataValue.count > maximumLength {
            throw LexiconValidatorError.bytesValueGreaterThankMaximumLength(value: dataValue, path: path, maximumLength: maximumLength)
        }

        if let minimumLength = definition.minimumLength, dataValue.count < minimumLength {
            throw LexiconValidatorError.bytesValueLessThanMinimumLength(value: dataValue, path: path, minimumLength: minimumLength)
        }
    }

    /// Validates a `CID` value.
    ///
    /// - Parameters:
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match an expected value.
    private static func validateCID(
        path: String,
        definition: ATCIDLinkType,
        value: PrimitiveValue?
    ) throws {
        guard let value, case .cid(_) = value else {
            throw LexiconValidatorError.invalidType(value: path, expectedType: "cid-link")
        }
    }

    /// Validates a unknown value.
    ///
    /// - Parameters:
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match an expected value.
    private static func validateUnknown(
        path: String,
        definition: ATUnknownType,
        value: PrimitiveValue?
    ) throws {
        guard let value,
              case .object(_) = value else {
            throw LexiconValidatorError.invalidType(value: path, expectedType: "object")
        }
    }
}
