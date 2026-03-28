//
//  XRPCValidator.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-03-07.
//

extension Validator.XRPC {

    /// Validates the appropriate XRPC parameter objects.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match the constant value.
    public static func validate(
        lexicons: LexiconRegistry,
        path: String,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        let parameterValue: [String: PrimitiveValue]

        if case .object(let objectValue) = value {
            parameterValue = objectValue
        } else {
            parameterValue = [:]
        }

        let objectDefinition: ATObjectType
        switch definition {
            case .object(let atObjectType):
                objectDefinition = atObjectType
            default:
                throw LexiconValidatorError.valueIsNotAnObject(path: path, value: value ?? "nil")
        }

        let requiredProperties = Set(objectDefinition.required ?? [])
        var resultValue = parameterValue

        if let requiredList = objectDefinition.required {
            for requiredKey in requiredList {
                let rawRequiredValue = parameterValue[requiredKey]

                if rawRequiredValue == nil, let propertyDefinition = objectDefinition.properties[requiredKey] {
                    if LexiconToolsUtilities.hasPrimitiveDefault(propertyDefinition) {
                        continue
                    }

                    throw LexiconValidatorError.objectRequiredPropertyNotFound(path: path, requiredKey: requiredKey)
                }
            }
        }

        for (key, propertyDefinition) in objectDefinition.properties {
            let rawPropertyValue = parameterValue[key]

            switch propertyDefinition {
                case .array(_):
                    continue
                default:
                    _ = try Validator.Primitive.validate(path: key, definition: propertyDefinition, value: rawPropertyValue)
            }

            let isPropertyUndefined = rawPropertyValue == nil

            guard !isPropertyUndefined, !requiredProperties.contains(key) else {
                throw LexiconValidatorError.objectRequiredPropertyNotFound(path: path, requiredKey: key)
            }

            if !isPropertyUndefined {
                return
            }

            if let rawPropertyValue {
                resultValue[key] = rawPropertyValue
            }
        }
    }
}
