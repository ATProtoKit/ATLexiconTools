//
//  LexiconRegistry.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-08-09.
//

/// A registry for storing entire lexicon objects alongside their individual definitions.
public final class LexiconRegistry: Sequence {

    /// A private property for dictionary representing the lexicon storage.
    private var lexicons: [String: Lexicon] = [:]

    /// A private property for the dictionary containing lexicon definitions.
    private var definitions: [String: LexiconDefinition] = [:]

    /// Initializes an instance of `LexiconRegistry` by extravting the definitions from the `Lexicon` array.
    ///
    /// - Parameter lexicons: An array of `Lexicon` objects. Optional. Defaults to `nil`.
    public init(lexicons: [Lexicon]? = nil) throws {
        guard let lexicons else {
            return
        }

        for lexicon in lexicons {
            try self.add(lexicon: lexicon)
        }
    }

    public nonisolated func makeIterator() -> [String: Lexicon].Values.Iterator {
        return self.lexicons.values.makeIterator()
    }

    /// Adds a `Lexicon` object to the `LexiconRegistery` instance.
    ///
    /// - Parameter lexicon: The `Lexicon` ibject to add.
    ///
    /// - Throws: An error if the lexicon has already been registered or if the URI resolution fails.
    public func add(lexicon: Lexicon) throws {
        let normalizedBaseURI = try LexiconToolsUtilities.toLexiconURI(from: lexicon.id)

        // There shouldn't be any duplicates in the collection.
        guard self.lexicons[normalizedBaseURI] == nil else {
            throw LexiconRegistryError.lexiconAlreadyRegistered(nsid: normalizedBaseURI)
        }

        var resolvedDefinitions: [String: LexiconDefinition] = [:]

        for (definitionName, definitionValue) in lexicon.definitions {
            resolvedDefinitions[definitionName] = try self.resolveReferenceURIs(
                in: definitionValue,
                baseURI: normalizedBaseURI
            )
        }

        let resolvedLexicon = try Lexicon(
            lexicon: lexicon.lexicon,
            id: lexicon.id,
            definitions: resolvedDefinitions
        )

        self.lexicons[normalizedBaseURI] = resolvedLexicon

        for (definitionKey, definitionValue) in self.iterateDefinitions(for: resolvedLexicon) {
            self.definitions[definitionKey] = definitionValue
        }
    }

    /// Removes a lexicon entry.
    ///
    /// - Parameter uri: The URI of the lexicon.
    ///
    /// - Throws: An error if lexicon being
    public func remove(by uri: String) throws {
        let uri = try LexiconToolsUtilities.toLexiconURI(from: uri)

        guard let lexicon = try self.getLexicon(from: uri) else {
            throw LexiconRegistryError.cannotRemoveLexiconAsItDoesNotExist(uri: uri)
        }

        for (uri, _) in self.iterateDefinitions(for: lexicon) {
            self.definitions[uri] = nil
        }
    }

    /// Retrieves a lexicon from the provided URI.
    ///
    /// - Parameter uri: The lexicon URI associated with the lexicon to retrieve.
    /// - Returns: The `Lexicon` object associated with the URI if valid, or `nil` if not.
    public func getLexicon(from uri: String) throws -> Lexicon? {
        let uri = try LexiconToolsUtilities.toLexiconURI(from: uri)
        return self.lexicons[uri]
    }

    /// Retrieves the definition of a lexicon.
    ///
    /// - Parameters:
    ///   - uri: The lexicon's URI.
    ///   - allowedTypes: An array of strings used for filtering the objwct types the definition has.
    ///   Optional. Defaults to `nil`.
    ///   - shouldNormalizeURI: Determines whether the method should normalize the URI. Defaults to `false`.
    /// - Returns: A `LwxiconDefinition` object.
    public func getDefinition(by uri: String, types allowedTypes: [String]? = nil, shouldNormalizeURI: Bool = false) throws -> LexiconDefinition {
        let normalizedURI: String

        switch shouldNormalizeURI {
            case true:
                normalizedURI = try LexiconToolsUtilities.toLexiconURI(from: uri)
            case false:
                normalizedURI = uri
        }

        guard let definition = self.definitions[normalizedURI] else {
            throw LexiconRegistryError.lexiconNotFound(uri: normalizedURI)
        }

        if let allowed = allowedTypes, !allowed.isEmpty {
            if !allowed.contains(definition.type) {
                throw LexiconRegistryError.notOfType(expected: allowed, actual: definition.type, uri: normalizedURI)
            }
        }

        return definition
    }

    /// Validates a record or object definition.
    ///
    /// - Parameters:
    ///   - lexiconURI: The URI of the lexicon to validate.
    ///   - value: An `PrimitiveValue` object, representing the actual definition. Optional.
    ///   Defaults to `nil`.
    /// - Returns: The validated `PrimitiveValue` object.
    ///
    /// - Throws: An error if the lexicon isn't an object or a record.
    public func validate(lexiconURI: String, value: PrimitiveValue? = nil) throws -> PrimitiveValue {
        let normalizedURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)
        let definition = try self.getDefinition(by: normalizedURI, types: ["record", "object"])

        guard case .object = value else {
            throw LexiconRegistryError.notOfType(expected: ["object"], actual: definition.type, uri: normalizedURI)
        }

        switch definition {
            case .record(let record):
                return try Validator.Complex.validateObject(
                    lexicons: self,
                    path: "Record",
                    definition: ATObjectType(properties: record.record.properties),
                    value: value
                )
            case .object(let object):
                return try Validator.Complex.validateObject(
                    lexicons: self,
                    path: "Object",
                    definition: object,
                    value: value
                )
            default:
                throw LexiconRegistryError.notOfType(expected: ["record", "object"], actual: definition.type, uri: normalizedURI)
        }
    }

    /// Validates a record definition.
    ///
    /// - Parameters:
    ///   - lexiconURI: The URI of the lexicon to validate.
    ///   - value: An `PrimitiveValue` object, representing the actual definition. Optional.
    ///   Defaults to `nil`.
    /// - Returns: The validated `PrimitiveValue` object.
    ///
    /// - Throws: An error if the lexicon isn't an object or a record.
    public func validateRecord(by lexiconURI: String, value: PrimitiveValue? = nil) throws -> PrimitiveValue {
        let normalizedURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)
        let definition = try self.getDefinition(by: normalizedURI, types: ["record"])

        guard case .object(let recordValue) = value else {
            throw LexiconRegistryError.notOfType(expected: ["object"], actual: definition.type, uri: normalizedURI)
        }

        guard case .string(let rawType)? = recordValue["$type"] else {
            throw LexiconRegistryError.typeIsNotAString
        }

        let normalizedRecordType = try LexiconToolsUtilities.toLexiconURI(from: rawType)

        if normalizedRecordType != normalizedURI {
            throw LexiconRegistryError.invalidType(expectedValue: normalizedURI, actualValue: rawType)
        }

        return try Validator.validateRecord(lexicons: self, definition: definition, value: value)
    }

    /// Validates XRPC parameters.
    ///
    /// - Parameters:
    ///   - lexiconURI: The URI of the lexicon to validate.
    ///  - value: An `PrimitiveValue` object, representing the actual definition. Optional.
    ///   Defaults to `nil`.
    /// - Returns: The validated `PrimitiveValue` object.
    ///
    /// - Throws: An error if the parameters aren't valid.
    public func validateXRPCParameters(by lexiconURI: String, value: PrimitiveValue? = nil) throws -> PrimitiveValue {
        let normalizedLexiconURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)
        let definition = try self.getDefinition(by: normalizedLexiconURI, types: ["query", "procedure", "subscription"])
        let parameters: ATParamsType?

        switch definition {
            case .query(let queryDefinition):
                parameters = queryDefinition.parameters
            case .procedure(let procedureDefinition):
                parameters = procedureDefinition.parameters
            case .subscription(let subscriptionDefinition):
                parameters = subscriptionDefinition.parameters
            default:
                parameters = nil
        }

        guard let parameters else {
            return value ?? .object([:])
        }

        return try Validator.Complex.validateObject(
            lexicons: self,
            path: "Params",
            definition: try LexiconToolsUtilities.objectDefinition(from: parameters),
            value: value ?? .object([:])
        )
    }

    /// Validates an XRPC input body.
    ///
    /// - Parameters:
    ///   - lexiconURI: The URI of the lexicon to validate.
    ///   - value: An `PrimitiveValue` object, representing the actual definition. Optional.
    ///   Defaults to `nil`.
    /// - Returns: The validated `PrimitiveValue` object.
    ///
    /// - Throws: An error if the inputs aren't valid.
    public func validateXRPCInput(by lexiconURI: String, value: PrimitiveValue? = nil) throws -> PrimitiveValue {
        let normalizedLexiconURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)
        let definition = try self.getDefinition(by: normalizedLexiconURI, types: ["procedure"])
        let schema: ATReferenceType?

        switch definition {
            case .procedure(let procedureDefinition):
                schema = procedureDefinition.input?.schema
            default:
                schema = nil
        }

        guard let schema else {
            return value ?? .object([:])
        }

        return try Validator.Complex.validateOneOf(
            lexicons: self,
            path: "Input",
            definition: .reference(schema),
            value: value ?? .object([:]),
            isObject: true
        )
    }

    /// Validates an XRPC output body.
    ///
    /// - Parameters:
    ///   - lexiconURI: The URI of the lexicon to validate.
    ///   - value: An `PrimitiveValue` object, representing the actual definition. Optional.
    ///   Defaults to `nil`.
    /// - Returns: The validated `PrimitiveValue` object.
    ///
    /// - Throws: An error if the outputs aren't valid.
    public func validateXRPCOutput(by lexiconURI: String, value: PrimitiveValue? = nil) throws -> PrimitiveValue {
        let normalizedLexiconURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)

        let definition = try self.getDefinition(by: normalizedLexiconURI, types: ["query", "procedure"])
        let schema: ATReferenceType?

        switch definition {
            case .query(let queryDefinition):
                schema = queryDefinition.output?.schema
            case .procedure(let procedureDefinition):
                schema = procedureDefinition.output?.schema
            default:
                schema = nil
        }

        guard let schema else {
            return value ?? .object([:])
        }

        return try Validator.Complex.validateOneOf(
            lexicons: self,
            path: "Output",
            definition: .reference(schema),
            value: value ?? .object([:]),
            isObject: true
        )
    }

    /// Validates an XRPC subscription message.
    ///
    /// - Parameter lexiconURI: The URI of the lexicon to validate.
    public func validateXRPCMessage(by lexiconURI: String) throws {
        let normalizedLexiconURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)
        
        _ = try self.getDefinition(by: normalizedLexiconURI, types: ["subscription"])
    }

    /// Iterates through definitions in the `Lexicon` object to conform them to the format needed
    /// before entering them inside the `LexiconRegistry` instance.
    ///
    /// - Parameter lexicon: The `Lexicon` object to validate.
    private func iterateDefinitions(for lexicon: Lexicon) -> [(String, LexiconDefinition?)] {
        var result: [(String, LexiconDefinition?)] = []

        for (definitionID, _) in lexicon.definitions {
            result.append(("lex:\(lexicon.id)#\(definitionID)", lexicon.definitions[definitionID]))

            if definitionID == "main" {
                result.append(("lex:\(lexicon.id)", lexicon.definitions[definitionID]))
            }
        }

        return result
    }

    /// Resolves all relative references inside a definition.
    ///
    /// - Parameters:
    ///   - definition: The definition to normalize.
    ///   - baseURI: The lexicon URI used to resolve relative anchors.
    ///
    /// - Returns: A new instance of `LexiconDefinition`, with all relative references normalized.
    ///
    /// - Throws: An error if a relative URI can't be resolved.
    private func resolveReferenceURIs(in definition: LexiconDefinition, baseURI: String) throws -> LexiconDefinition {
        switch definition {
            case .reference(let referenceType):
                return .reference(
                    ATReferenceType(
                        reference: try LexiconToolsUtilities.toLexiconURI(
                            from: referenceType.reference,
                            resolvedAgainst: baseURI
                        )
                    )
                )

            case .union(let unionType):
                let resolvedReferences = try unionType.references?.map { reference in
                    try LexiconToolsUtilities.toLexiconURI(
                        from: reference,
                        resolvedAgainst: baseURI
                    )
                }

                return .union(
                    ATUnionType(
                        references: resolvedReferences,
                        isClosed: unionType.isClosed
                    )
                )

            case .array(let arrayType):
                let resolvedItems = try self.resolveReferenceURIs(
                    in: arrayType.items,
                    baseURI: baseURI
                )

                return .array(
                    ATArrayType(
                        items: resolvedItems,
                        minimumLength: arrayType.minimumLength,
                        maximumLength: arrayType.maximumLength
                    )
                )

            case .object(let objectType):
                var resolvedProperties: [String: LexiconDefinition] = [:]

                for (propertyName, propertyDefinition) in objectType.properties {
                    resolvedProperties[propertyName] = try self.resolveReferenceURIs(
                        in: propertyDefinition,
                        baseURI: baseURI
                    )
                }

                return .object(
                    try ATObjectType(
                        description: objectType.description,
                        properties: resolvedProperties,
                        required: objectType.required,
                        nullable: objectType.nullable
                    )
                )

            case .record(let recordType):
                let resolvedRecordObjectDefinition = try self.resolveReferenceURIs(
                    in: .object(recordType.record),
                    baseURI: baseURI
                )

                guard case .object(let resolvedRecordObject) = resolvedRecordObjectDefinition else {
                    return definition
                }

                return .record(
                    RecordDefinition(
                        description: recordType.description,
                        key: recordType.key,
                        record: resolvedRecordObject
                    )
                )

            default:
                return definition
        }
    }
}
