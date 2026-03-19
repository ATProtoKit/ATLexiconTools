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
        let uri = try LexiconToolsUtilities.toLexiconURI(from: lexicon.id)

        guard self.lexicons[uri] == nil else {
            throw LexiconRegistryError.lexiconAlreadyRegistered(nsid: uri)
        }

        self.lexicons[uri] = lexicon

        if !lexicon.definitions.isEmpty {
            for (key, value) in self.iterateDefinitions(for: lexicon) {
                self.definitions[key] = value
            }
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
    ///   - Returns: A `LwxiconDefinition` object.
    public func getDefinition(by uri: String, types allowedTypes: [String]? = nil) throws -> LexiconDefinition {
        let uri = try LexiconToolsUtilities.toLexiconURI(from: uri)

        guard let definition = self.definitions[uri] else {
            throw LexiconRegistryError.lexiconNotFound(uri: uri)
        }

        if let allowed = allowedTypes, !allowed.isEmpty {
            if !allowed.contains(definition.type) {
                throw LexiconRegistryError.notOfType(expected: allowed, actual: definition.type, uri: uri)
            }
        }

        return definition
    }

    /// Validates a record or object definition.
    ///
    /// - Parameters:
    ///   - lexiconURI: The URI of the lexicon to validate.
    ///   - value: An `PrimitiveValue` object, representing the actual definition.
    ///
    ///   - Throws: An error if the lexicon isn't an object or a record.
    public func validate(lexiconURI: String, value: PrimitiveValue? = nil) throws {
        let normalizedURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)
        let definition = try self.getDefinition(by: normalizedURI, types: ["record", "object"])

        guard case .object = value else {
            throw LexiconRegistryError.notOfType(expected: ["object"], actual: definition.type, uri: normalizedURI)
        }

        switch definition {
            case .record(let record):
                try Validator.Complex.validateObject(
                    lexicons: self,
                    path: "Record",
                    definition: ATObjectType(properties: record.record.properties),
                    value: value
                )

                return
            case .object(let object):
                try Validator.Complex.validateObject(
                    lexicons: self,
                    path: "Object",
                    definition: object,
                    value: value
                )

                return
            default:
                throw LexiconRegistryError.notOfType(expected: ["record", "object"], actual: definition.type, uri: normalizedURI)
        }
    }

    /// Validates a record definition.
    ///
    /// - Parameters:
    ///   - lexiconURI: The URI of the lexicon to validate.
    ///   - value: An `PrimitiveValue` object, representing the actual definition. Optional. Defaults to `nil`.
    ///
    ///   - Throws: An error if the lexicon isn't an object or a record.
    public func validateRecord(by lexiconURI: String, value: PrimitiveValue? = nil) throws {
        let normalizedURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)
        let definition = try self.getDefinition(by: normalizedURI, types: ["record"])

        guard case .object(let recordValue) = value else {
            throw LexiconRegistryError.notOfType(expected: ["object"], actual: definition.type, uri: normalizedURI)
        }

        guard case .string(let rawType)? = recordValue["$type"] else {
            throw LexiconRegistryError.typeIsNotAString
        }

        if try LexiconToolsUtilities.toLexiconURI(from: lexiconURI) != normalizedURI {
            throw LexiconRegistryError.invalidType(expectedValue: normalizedURI, actualValue: rawType)
        }

        try Validator.validateRecord(lexicons: self, definition: definition, value: value)
    }

    /// Validates XRPC parameters.
    ///
    /// - Parameter lexiconURI: The URI of the lexicon to validate.
    public func validateXRPCParameters(by lexiconURI: String) throws {
        let normalizedLexiconURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)

        _ = try self.getDefinition(by: normalizedLexiconURI, types: ["query,", "procedure", "subscription"])
    }

    /// Validates an XRPC input body.
    ///
    /// - Parameter lexiconURI: The URI of the lexicon to validate.
    public func validateXRPCInput(by lexiconURI: String) throws {
        let normalizedLexiconURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)

        _ = try self.getDefinition(by: normalizedLexiconURI, types: ["procedure"])
    }

    /// Validates an XRPC output body.
    ///
    /// - Parameter lexiconURI: The URI of the lexicon to validate.
    public func validateXRPCOutput(by lexiconURI: String) throws {
        let normalizedLexiconURI = try LexiconToolsUtilities.toLexiconURI(from: lexiconURI)
        
        _ = try self.getDefinition(by: normalizedLexiconURI, types: ["query", "procedure"])
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
}
