//
//  PrimitiveSchemaValidator.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-08-19.
//

import Foundation

extension Validator.Schema {

    /// Validates the lexicon schema for integers.
    ///
    /// - Parameter integerSchema: The `ATIntegerType` object to validate.
    ///
    /// - Throws: `LexiconSchemaValidatorError.invalidSchema` if the schema is invalid.
    public static func validateInteger(integerSchema: ATIntegerType) throws {
        // Check to make sure the minimum number is lower than the maximum number (if they exist).
        if let minimumValue = integerSchema.minimum, let maximumValue = integerSchema.maximum {
            guard minimumValue <= maximumValue else {
                throw LexiconSchemaValidatorError
                    .invalidSchema(reason: "The minimum value (\(minimumValue)) for an integer cannot be higher than the maximum value (\(maximumValue))."
                )
            }
        }

        // If the "constant" value exists, search through the "enumValues" array (if they extst) to make sure that value is one of those numbers.
        if let constantValue = integerSchema.constant, let enumValues = integerSchema.enumValues {
            guard enumValues.contains(constantValue) else {
                throw LexiconSchemaValidatorError.invalidSchema(reason: "The contant value must be one the of the following numbers: \(enumValues)."
                )
            }
        }

        // If the "enumValues" array exists, loop through them to make sure they are within the minimum and maximum values (if they exist).
        if let enumValues = integerSchema.enumValues {
            for enumValue in enumValues {
                if let minimumValue = integerSchema.minimum, enumValue < minimumValue {
                    throw LexiconSchemaValidatorError
                        .invalidSchema(reason: "The enumValues array must contain numbers that are equal to or higher than the mminimum value.")
                }

                if let maximumValue = integerSchema.maximum, enumValue > maximumValue {
                    throw LexiconSchemaValidatorError
                        .invalidSchema(reason: "The enumValues array must contain numbers that are equal to or lower than the maximum value.")
                }
            }
        }
    }

    /// Validates the lexicon schema for strings.
    ///
    /// - Parameter stringSchema: The `ATStringType` object to validate.
    ///
    /// - Throws: `LexiconSchemaValidatorError.invalidSchema` if the schema is invalid.
    public static func validateString(stringSchema: ATStringType) throws {
        // Check to make sure the minimum number is lower than the maximum number (if they exist).
        if let minimumGraphemes = stringSchema.minimumGraphemes, let maximumGraphemes = stringSchema.maximumGraphemes {
            if minimumGraphemes > maximumGraphemes {
                throw LexiconSchemaValidatorError
                    .invalidSchema(reason:
                        """
                        Minimum string length (\(minimumGraphemes)) for the string's character count cannot be higher than
                        the maximum valueh (\(maximumGraphemes)).
                        """
                    )
            }
        }

        // Check to make sure the minimum number (for Unicode scalars) is lower than the maximum number (for Unicode scalars).
        if let minimumUnicodeScalars = stringSchema.minimumLength, let maximumUnicodeScalars = stringSchema.maximumLength {
            guard minimumUnicodeScalars <= maximumUnicodeScalars else {
                throw LexiconSchemaValidatorError
                    .invalidSchema(reason:
                    """
                    Minimum string length (\(minimumUnicodeScalars)) for the string's Unicode scalar count cannot be higher than
                    the maximum value (\(maximumUnicodeScalars)).
                    """
                )
            }
        }

        // If the "enumValues" array exists, loop through them to make sure the constant value (if it exists) is contained within the array.
        if let enumValues = stringSchema.enumValues, let constantValue = stringSchema.constantValue, let constant = stringSchema.constantValue {
            guard enumValues.contains(constant) else {
                throw LexiconSchemaValidatorError.invalidSchema(reason: "The string value \"\(constantValue)\" is not contained in the enumValues array.")
            }
        }

        // If the "knownValues" array exists, loop through them to make sure the "enumValues" array (if it exists) is contained within the array.
        if let knownValues = stringSchema.knownValues, let enumValues = stringSchema.enumValues {
            for value in knownValues {
                guard enumValues.contains(value) else {
                    throw LexiconSchemaValidatorError.invalidSchema(reason: "The string value \"\(value)\" is not contained in the enumValues array.")
                }
            }
        }
    }

    /// Validates the lexicon schema for bytes.
    ///
    /// - Parameter bytesSchema: The `ATBytesType` object to validate.
    ///
    /// - Throws: `LexiconSchemaValidatorError.invalidSchema` if the schema is invalid.
    public static func validateBytes(bytesSchema: ATBytesType) throws {
        // Check to make sure the minimum number is lower than the maximum number (if they exist).
        if let minimumLength = bytesSchema.minimumLength, let maximumLength = bytesSchema.maximumLength {
            guard minimumLength <= maximumLength else {
                throw LexiconSchemaValidatorError.invalidSchema(reason:
                    """
                    The minimum number of bytes (\(minimumLength)) must be less than or equal to the maximum number of bytes (\(maximumLength)).
                    """
                )
            }
        }
    }
}
