//
//  CodableValue.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A type-safe and thread-safe representation of JSON-compatible values, used for encoding and
/// decoding arbitrary JSON data.
public enum CodableValue: Codable, Sendable, Equatable, Hashable {

    /// Stores a `Bool` value.
    case bool(Bool)

    /// Stores an `Int` value.
    case int(Int)

    /// Stores a `Double` value.
    case double(Double)

    /// Stores a `String` value.
    case string(String)

    /// Stores an `Array` of `CodableValue` elements.
    case array([CodableValue])

    /// Stores a `Dictionary` with `String` keys and `CodableValue` values.
    case dictionary([String: CodableValue])

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
        } else if let value = try? container.decode([CodableValue].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: CodableValue].self) {
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
            case .bool(let value):
                try container.encode(value)
            case .int(let value):
                try container.encode(value)
            case .double(let value):
                try container.encode(value)
            case .string(let value):
                try container.encode(value)
            case .array(let value):
                try container.encode(value)
            case .dictionary(let value):
                try container.encode(value)
        }
    }
}

extension CodableValue: ExpressibleByBooleanLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral,
                        ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {

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

    public typealias ArrayLiteralElement = CodableValue

    public init(arrayLiteral: ArrayLiteralElement...) {
        var array: [CodableValue] = []

        for element in arrayLiteral {
            array.append(element)
        }

        self = .array(array)
    }

    public typealias Key = String
    public typealias Value = CodableValue

    public init(dictionaryLiteral elements: (Key, Value)...) {
        var dictionary: [String: CodableValue] = [:]

        for (key, value) in elements {
            // Add entry to dictionary.
            dictionary[key] = value
        }

        self = .dictionary(dictionary)
    }
}
