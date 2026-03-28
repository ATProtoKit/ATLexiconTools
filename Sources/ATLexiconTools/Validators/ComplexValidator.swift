//
//  ComplexValidator.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-02-27.
//

extension Validator.Complex {

    /// Validates the appropriate primitive value.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    /// - Returns: The validated `PrimitiveValue` object.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match the constant value.
    public static func validate(
        lexicons: LexiconRegistry,
        path: String,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws -> PrimitiveValue {
        switch definition {
            case .object(let atObject):
                return try Validator.Complex.validateObject(lexicons: lexicons, path: path, definition: atObject, value: value)
            case .array(let atArray):
                return try Validator.Complex.validateArray(lexicons: lexicons, path: path, definition: atArray, value: value)
            case .blob(_):
                try Validator.Blob.validateBlob(in: lexicons, at: path, definition: definition, value: value)
                return value ?? .nil
            case .boolean, .integer, .string, .bytes, .cidLink, .unknown:
                return try Validator.Primitive.validate(path: path, definition: definition, value: value)
            default:
                throw LexiconValidatorError.unexpectedLexiconType(type: definition.type)
        }
    }

    /// Validates array values.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    /// - Returns: The validated `PrimitiveValue` object.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match the constant value.
    internal static func validateArray(
        lexicons: LexiconRegistry,
        path: String,
        definition: ATArrayType,
        value: PrimitiveValue?
    ) throws -> PrimitiveValue {
        guard let value, case .array(let arrayValue) = value else {
            throw LexiconValidatorError.valueIsNotArray(path: path)
        }

        guard definition.type == "array" else {
            throw LexiconValidatorError.valueIsNotArray(path: path)
        }

        if let maximumLength = definition.maximumLength, arrayValue.count > maximumLength {
            throw LexiconValidatorError.arrayElementsGreaterThanMaximumLength(path: path, arrayElementNumber: maximumLength)
        }

        if let minimumLength = definition.minimumLength, arrayValue.count < minimumLength {
            throw LexiconValidatorError.arrayElementsFewerThanMinimumLength(path: path, arrayElementNumber: minimumLength)
        }

        var normalizedValues: [PrimitiveValue] = []

        for (index, itemValue) in arrayValue.enumerated() {
            let itemPath = "\(path)/\(index)"
            let normalizedValue = try validateOneOf(
                lexicons: lexicons,
                path: itemPath,
                definition: definition.items,
                value: itemValue
            )

            normalizedValues.append(normalizedValue)
        }

        return .array(normalizedValues)
    }

    /// Validates object values.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    /// - Returns: The validated `PrimitiveValue` object.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match the constant value.
    internal static func validateObject(
        lexicons: LexiconRegistry,
        path: String,
        definition: ATObjectType,
        value: PrimitiveValue?
    ) throws -> PrimitiveValue {
        guard let value,
              case .object(let objectValue) = value else {
            throw LexiconValidatorError.valueIsNotObject(path: path)
        }

        let requiredProperties = Set(definition.required ?? [])
        let nullableProperties = Set(definition.nullable ?? [])
        var resultValue = objectValue

        if let requiredList = definition.required {
            for requiredKey in requiredList {
                let rawRequiredValue = objectValue[requiredKey]

                if rawRequiredValue == nil, let propertyDefinition = definition.properties[requiredKey] {
                    if LexiconToolsUtilities.primitiveDefaultValue(for: propertyDefinition) != nil {
                        continue
                    }

                    throw LexiconValidatorError.objectRequiredPropertyNotFound(path: path, requiredKey: requiredKey)
                }
            }
        }

        for (key, propertyDefinition) in definition.properties {
            let rawPropertyValue = objectValue[key]

            if let rawPropertyValue, rawPropertyValue.isNil, nullableProperties.contains(key) {
                continue
            }

            if rawPropertyValue == nil, !requiredProperties.contains(key) {
                if LexiconToolsUtilities.primitiveDefaultValue(for: propertyDefinition) == nil {
                    continue
                }
            }

            let propertyPath = "\(path)/\(key)"

            let normalizedValue = try validateOneOf(
                lexicons: lexicons,
                path: propertyPath,
                definition: propertyDefinition,
                value: rawPropertyValue
            )

            resultValue[key] = normalizedValue
        }

        return .object(resultValue)
    }

    /// Validates a value against one or more schema variants.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///   - isObject: Determines whether the value is an object. Defaults to `false`.
    /// - Returns: The validated `PrimitiveValue` object.
    ///
    /// - Throws: An error if the value isn't available, or if the value doesn't match the constant value.
    internal static func validateOneOf(
        lexicons: LexiconRegistry,
        path: String,
        definition: LexiconDefinition,
        value: PrimitiveValue?,
        isObject: Bool = false
    ) throws -> PrimitiveValue {
        let concreteDefinitions: [LexiconDefinition]

        switch definition {
            case .union(let unionType):
                guard let unionTypeReference = unionType.references,
                      let value,
                      case .object(let discriminated) = value,
                      case .string(let type)? = discriminated["$type"] else {
                    throw LexiconValidatorError.objectMustInclude$typeProperty(path: path)
                      }

                if try !LexiconToolsUtilities.refencesContainType(references: unionTypeReference, type: type) {
                    if unionType.isClosed == true {
                        throw LexiconValidatorError.unionObject$typeValueNotFound(path: path, references: unionTypeReference.joined(separator: ", "))
                    }

                    return value
                }

                concreteDefinitions = try LexiconToolsUtilities.toConcreteTypes(lexicons: lexicons, definition: .reference(ATReferenceType(reference: type)))
            default:
                concreteDefinitions = try LexiconToolsUtilities.toConcreteTypes(lexicons: lexicons, definition: definition)
        }

        for concreteDefinition in concreteDefinitions {
            switch isObject {
                case true:
                    guard case .object(let aTObjectType) = concreteDefinition else {
                        throw LexiconValidatorError.valueIsNotObject(path: path)
                    }

                    return try Validator.Complex.validateObject(
                        lexicons: lexicons,
                        path: path,
                        definition: aTObjectType,
                        value: value
                    )
                case false:
                    return try Validator.Complex.validate(
                        lexicons: lexicons,
                        path: path,
                        definition: concreteDefinition,
                        value: value
                    )
            }
        }

        return value ?? .nil
    }
}
