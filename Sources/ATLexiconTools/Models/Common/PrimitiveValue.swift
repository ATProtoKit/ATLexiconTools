//
//  PrimitiveValue.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-02-22.
//

import Foundation
import MultiformatsKit

/// An enumeration representing a primitive value.
public enum PrimitiveValue: Codable, Sendable, Equatable {

    /// A `nil` value.
    case `nil`

    /// A `Bool` value.
    case bool(Bool)

    /// An `Int` value.
    case int(Int)

    /// A `Double` value.
    case double(Double)

    /// A `String` value.
    case string(String)

    /// A `Data` value.
    case bytes(Data)

    /// A `CID` value.
    case cid(CID)

    /// A blob reference value.
    case blob(BlobReference)

    /// An array value.
    case array([PrimitiveValue])

    /// A dictionary value.
    case dictionary([String: PrimitiveValue])

    /// Returns the wrapped object value.
    public var dictionaryValue: [String: PrimitiveValue]? {
        guard case .dictionary(let value) = self else {
            return nil
        }
        return value
    }

    /// Returns the wrapped array value.
    public var arrayValue: [PrimitiveValue]? {
        guard case .array(let value) = self else {
            return nil
        }
        return value
    }

    /// Returns the wrapped string value.
    public var stringValue: String? {
        guard case .string(let value) = self else {
            return nil
        }
        return value
    }

    /// Returns the wrapped integer value.
    public var integerValue: Int? {
        guard case .int(let value) = self else {
            return nil
        }
        return value
    }

    /// Returns the wrapped boolean value.
    public var booleanValue: Bool? {
        guard case .bool(let value) = self else {
            return nil
        }
        return value
    }

    /// Returns the wrapped binary value.
    public var bytesValue: Data? {
        guard case .bytes(let value) = self else {
            return nil
        }
        return value
    }

    /// Returns the wrapped CID value.
    public var cidValue: CID? {
        guard case .cid(let value) = self else {
            return nil
        }
        return value
    }

    /// Returns the wrapped blob reference value.
    public var blobValue: BlobReference? {
        guard case .blob(let value) = self else {
            return nil
        }
        return value
    }

    /// Indicates whether the value is null.
    public var isNil: Bool {
        if case .nil = self {
            return true
        }
        return false
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([PrimitiveValue].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: PrimitiveValue].self) {
            self = .dictionary(value)
        } else {
            throw DecodingError.typeMismatch(
                CodableValue.self,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unsupported value"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .nil:
                try container.encodeNil()
            case .bool(let value):
                try container.encode(value)
            case .int(let value):
                try container.encode(value)
            case .double(let value):
                try container.encode(value)
            case .string(let value):
                try container.encode(value)
            case .bytes(let value):
                try container.encode(value)
            case .cid(let value):
                try container.encode(value)
            case .blob(let value):
                try container.encode(value)
            case .array(let value):
                try container.encode(value)
            case .dictionary(let value):
                try container.encode(value)
        }
    }

    public static func == (lhs: PrimitiveValue, rhs: PrimitiveValue) -> Bool {
        switch (lhs, rhs) {
            case (.nil, .nil):
                return true
            case let (.bool(left), .bool(right)):
                return left == right
            case let (.int(left), .int(right)):
                return left == right
            case let (.double(left), .double(right)):
                return left == right
            case let (.string(left), .string(right)):
                return left == right
            case let (.bytes(left), .bytes(right)):
                return left == right
            case let (.cid(left), .cid(right)):
                return left == right
            case let (.array(left), .array(right)):
                return left.count == right.count && zip(left, right).allSatisfy(==)
            case let (.dictionary(left), .dictionary(right)):
                guard left.count == right.count else {
                    return false
                }
                for (key, leftValue) in left {
                    guard leftValue == right[key] else {
                        return false
                    }
                }
                return true
            default:
                return false
        }
    }
}

extension PrimitiveValue: ExpressibleByNilLiteral, ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral,
                               ExpressibleByStringLiteral, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {

    public init(nilLiteral: ()) {
        self = .nil
    }

    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }


    public init(integerLiteral value: Int) {
        self = .int(value)
    }

    public init(floatLiteral value: Double) {
        self = .double(value)
    }

    public init(stringLiteral value: String) {
        self = .string(value)
    }

    public init(arrayLiteral elements: PrimitiveValue...) {
        self = .array(elements)
    }

    public init(dictionaryLiteral elements: (String, PrimitiveValue)...) {
        var dictionary: [String: PrimitiveValue] = [:]
        for (key, value) in elements {
            dictionary[key] = value
        }
        self = .dictionary(dictionary)
    }
}
