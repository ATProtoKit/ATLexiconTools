//
//  LexiconDefinition.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// An enumeration representing the primary lexicon definitions.
public enum LexiconDefinition: Codable, Sendable {

    /// Describes an object to be stored in a repository record.
    case record(RecordDefinition)

    /// Describes an HTTP GET query.
    case query(QueryDefinition)

    /// Describes an HTTP POST query.
    case procedure(ProcedureDefinition)

    /// Describes a Websocket query.
    case subscription(SubscriptionDefinition)

    /// Describes a permission set query.
    case permissionSet(PermissionSetDefinition)

    /// An `blob` object.
    case blob(ATBlobType)

    /// An `array` object.
    case array(ATArrayType)

    /// A `token` object.
    case token(ATTokenType)

    /// An `object` object.
    case object(ATObjectType)

    /// A `boolean` object.
    case boolean(ATBooleanType)

    /// An `integer` object.
    case integer(ATIntegerType)

    /// A `string` object.
    case string(ATStringType)

    /// A `bytes` object.
    case bytes(ATBytesType)

    /// A `cid-link` object.
    case cidLink(ATCIDLinkType)

    /// A `unknown` object.
    case unknown(ATUnknownType)

    /// A `union` object.
    case union(ATUnionType)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Check if 'type' exists at all.
        guard container.contains(.type) else {
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Must have a type."
            )
        }

        // Check if 'type' is a String object.
        let type: String
        do {
            type = try container.decode(String.self, forKey: .type)
        } catch {
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Type property must be a string."
            )
        }

        switch type {
            case "record":
                self = .record(try RecordDefinition(from: decoder))
            case "query":
                self = .query(try QueryDefinition(from: decoder))
            case "procedure":
                self = .procedure(try ProcedureDefinition(from: decoder))
            case "subscription":
                self = .subscription(try SubscriptionDefinition(from: decoder))
            case "permission-set":
                self = .permissionSet(try PermissionSetDefinition(from: decoder))
            case "blob":
                self = .blob(try ATBlobType(from: decoder))
            case "array":
                self = .array(try ATArrayType(from: decoder))
            case "token":
                self = .token(try ATTokenType(from: decoder))
            case "object":
                self = .object(try ATObjectType(from: decoder))
            case "boolean":
                self = .boolean(try ATBooleanType(from: decoder))
            case "integer":
                self = .integer(try ATIntegerType(from: decoder))
            case "string":
                self = .string(try ATStringType(from: decoder))
            case "bytes":
                self = .bytes(try ATBytesType(from: decoder))
            case "cid-link":
                self = .cidLink(try ATCIDLinkType(from: decoder))
            case "unknown":
                self = .unknown(try ATUnknownType(from: decoder))
            case "union":
                self = .union(try ATUnionType(from: decoder))
            default:
                let knownTypes = [
                    "record", "query", "procedure", "subscription", "blob", "array", "token", "object",
                    "boolean", "integer", "string", "bytes", "cid-link", "unknown"
                ].joined(separator: ", ")

                throw DecodingError.typeMismatch(
                    LexiconDefinition.self, DecodingError.Context(
                        codingPath: decoder.codingPath, debugDescription: "Invalid type: \(type). Must be one of: \(knownTypes)."))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .record(let value):
                try container.encode(value)
            case .query(let value):
                try container.encode(value)
            case .procedure(let value):
                try container.encode(value)
            case .subscription(let value):
                try container.encode(value)
            case .permissionSet(let value):
                try container.encode(value)
            case .blob(let value):
                try container.encode(value)
            case .array(let value):
                try container.encode(value)
            case .token(let value):
                try container.encode(value)
            case .object(let value):
                try container.encode(value)
            case .boolean(let value):
                try container.encode(value)
            case .integer(let value):
                try container.encode(value)
            case .string(let value):
                try container.encode(value)
            case .bytes(let value):
                try container.encode(value)
            case .cidLink(let value):
                try container.encode(value)
            case .unknown(let value):
                try container.encode(value)
            case .union(let value):
                try container.encode(value)
        }
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
    }

    /// Returns the `$type` value of the definition.
    public var type: String {
        switch self {
            case .record(let value):
                return value.type
            case .query(let value):
                return value.type
            case .procedure(let value):
                return value.type
            case .subscription(let value):
                return value.type
            case .permissionSet(let value):
                return value.type
            case .blob(let value):
                return value.type
            case .array(let value):
                return value.type
            case .token(let value):
                return value.type
            case .object(let value):
                return value.type
            case .boolean(let value):
                return value.type
            case .integer(let value):
                return value.type
            case .string(let value):
                return value.type
            case .bytes(let value):
                return value.type
            case .cidLink(let value):
                return value.type
            case .unknown(let value):
                return value.type
            case .union(let value):
                return value.type
        }
    }
}
