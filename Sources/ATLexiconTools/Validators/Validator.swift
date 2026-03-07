//
//  Validator.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-08-07.
//

/// Utility functions to validate lexicon JSON inputs and outputs.
public enum Validator {

    /// Functions for validating blob-related JSON inputs and outputs.
    public enum Blob {}

    /// Functions for validating non-primitive-related JSON inputs and outputs.
    public enum Complex {}

    /// Functions for validating format-related JSON inputs and outputs.
    public enum Format {}

    /// Functions for validating primitive-related JSON inputs and outputs.
    public enum Primitive {}

    /// Functions for validating XRPC-related JSON inputs and outputs.
    public enum XRPC {}
}

extension Validator {

    /// Validates the specified record.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the record is invalid.
    public static func validateRecord(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        try Validator.Complex.validate(
            lexicons: lexicons,
            path: "Record",
            definition: definition,
            value: value
        )
    }

    /// Validates the specified XRPC query parameters.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    public static func validateXRPCQuery(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        try Validator.validateXRPCParameters(
            lexicons: lexicons,
            definition: definition,
            value: value
        )
    }

    /// Validates the specified XRPC procedure parameters.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    public static func validateXRPCProcedure(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        try Validator.validateXRPCParameters(
            lexicons: lexicons,
            definition: definition,
            value: value
        )
    }

    /// Validates the specified XRPC subscription parameters.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    public static func validateXRPCSubscription(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        try Validator.validateXRPCParameters(
            lexicons: lexicons,
            definition: definition,
            value: value
        )
    }

    /// Validates the specified XRPC input parameters.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    public static func validateXRPCInput(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
//        guard case .subscription(let subscriptionDefinition) = definition else {
//            return
//        }

        try Validator.Complex.validateOneOf(
            lexicons: lexicons,
            path: "Input",
            definition: definition,
            value: value,
            isObject: true
        )
    }

    /// Validates the specified XRPC message.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    public static func validateXRPCMessage(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        guard case .subscription(let subscriptionDefinition) = definition else {
            return
        }

//        let schema = subscriptionDefinition.message?.schema

        try Validator.Complex.validateOneOf(
            lexicons: lexicons,
            path: "Message",
            definition: definition,
            value: value,
            isObject: true
        )
    }

    /// Validates the specified XRPC query output parameters.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    public static func validateXRPCQueryOutput(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        try Validator.validateXRPCOutput(
            lexicons: lexicons,
            definition: definition,
            value: value
        )
    }

    /// Validates the specified XRPC procedure parameters.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    public static func validateXRPCProcedureOutput(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        try Validator.validateXRPCOutput(
            lexicons: lexicons,
            definition: definition,
            value: value
        )
    }

    /// Validates the specified XRPC subscription parameters.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    public static func validateXRPCSubscriptionOutput(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        try Validator.validateXRPCOutput(
            lexicons: lexicons,
            definition: definition,
            value: value
        )
    }

    /// Validates an XRPC parameter.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    internal static func validateXRPCParameters(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition?,
        value: PrimitiveValue?
    ) throws {
//        guard case .subscription(let subscriptionDefinition) = definition else {
//            return
//        }
//
//        guard let parameters = subscriptionDefinition.parameters
        guard let definition else {
            return
        }

        try Validator.XRPC.validate(
            lexicons: lexicons,
            path: "Params",
            definition: definition,
            value: value
        )
    }

    /// Validates an XRPC output.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the XRPC parameter is invalid.
    internal static func validateXRPCOutput(
        lexicons: LexiconRegistry,
        definition: LexiconDefinition?,
        value: PrimitiveValue?
    ) throws {
        guard let definition else {
            return
        }

        try Validator.XRPC.validate(
            lexicons: lexicons,
            path: "Output",
            definition: definition,
            value: value
        )
    }
}
