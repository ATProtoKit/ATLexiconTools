//
//  Serialize.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-08-07.
//

import Foundation
import MultiformatsKit
import ATCommonWeb

/// Represents a value used in AT Protocol lexicons.
public enum LexiconValue {

    /// An IPLD-encoded value.
    case ipld(IPLD.IPLDValue)

    /// A reference to a blob.
    case blob(BlobReference)

    /// An array of `LexiconValue`s.
    indirect case array([LexiconValue])

    /// A dictionary of `String` keys to`LexiconValue`s.
    case dictionary([String: LexiconValue])

    /// Converts a `LexiconValue` object to an `IPLD.IPLDValue` object.
    ///
    /// - Parameter lexiconValue: The `LexiconValue` to convert.
    /// - Returns: The converted `IPLD.IPLDValue` object.
    ///
    /// - Throws: An error if `CID` conversion fails.
    public static func toIPLD(from lexiconValue: LexiconValue) throws -> IPLD.IPLDValue {
        switch lexiconValue {
            case .array(let array):
                return .array(try array.map { try toIPLD(from: $0) })

            case .dictionary(let dictionary):
                var result: [String: IPLD.IPLDValue] = [:]
                for (key, value) in dictionary {
                    result[key] = try toIPLD(from: value)
                }
                return .dictionary(result)
            case .blob(let blobReference):
                do {
                    let encodable = try blobReference.toIPLDRepresentation()
                    let dictionary: [String: IPLD.IPLDValue] = [
                        "$type": .jsonValue(.string(encodable.type)),
                        "ref": .dictionary([
                            "$link": .jsonValue(.string(encodable.reference.link))
                        ]),
                        "mimeType": .jsonValue(.string(encodable.mimeType)),
                        "size": .jsonValue(.number(encodable.size))
                    ]
                    return .dictionary(dictionary)
                } catch {
                    throw error
                }

            case .ipld(let ipldValue):
                return ipldValue
        }
    }

    /// Converts a `IPLD.IPLDValue` object to a `LexiconValue`.
    ///
    /// - Parameter ipldValue: The `IPLD.IPLDValue` object to convert.
    /// - Returns: The converted `LexiconValue` object.
    public static func toLexiconValue(from ipldValue: IPLD.IPLDValue) throws -> LexiconValue {
        switch ipldValue {
            case .array(let array):
                return .array(try array.map { try toLexiconValue(from: $0) })
            case .jsonValue(let jsonValue):
                return .ipld(.jsonValue(jsonValue))
            case .cid(let cid):
                return .ipld(.cid(cid))
            case .bytes(let data):
                return .ipld(.bytes(data))
            case .dictionary(let dictionary):
                // Check if it's a typed blob reference.
                if let blobReference = try? BlobReference(from: .dictionary(dictionary)) {
                    return .blob(blobReference)
                }

                // If not, then it's an untyped blob reference.
                var untypedDictionary: [String: LexiconValue] = [:]
                for (key, value) in dictionary {
                    untypedDictionary[key] = try toLexiconValue(from: value)
                }

                return .dictionary(untypedDictionary)
        }
    }

    /// Converts a `LexiconValue` to a `IPLD.JSONValue` object.
    ///
    /// - Parameter lexiconValue: The `LexiconValue` object to convert.
    /// - Returns: The converted `IPLD.JSONValue` object.
    ///
    /// - Throws: An error if `CID` conversion fails.
    public static func toJSONValue(from lexiconValue: LexiconValue) throws -> IPLD.JSONValue {
        return IPLD.ipldToJSON(try Self.toIPLD(from: lexiconValue))
    }

    /// Converts a `LexiconValue` object to a JSON object.
    ///
    /// This is the same as ``LexiconValue/toJSONValue(from:)``, but it does an extra step by converting it
    /// into the string representation of the JSON.
    ///
    /// - Parameter lexiconValue: The `LexiconValue` object to convert.
    /// - Returns: The converted JSON object.
    ///
    /// - Throws: An error if `CID` or UTF-8 conversion fails.
    public static func stringify(_ lexiconValue: LexiconValue) throws -> String {
        let json = try LexiconValue.toJSONValue(from: lexiconValue)
        let encoder = JSONEncoder()

        let data = try encoder.encode(json)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(
                json,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "UTF-8 conversion failed."
                )
            )
        }

        return jsonString
    }

    /// Converts an `IPLD.JSONValue` object to a `LexiconValue` object.
    ///
    /// - Parameter jsonValue: The `IPLD.JSONValue` object to convert.
    /// - Returns: The converted `LexiconValue` object.
    ///
    /// - Throws: An error if `CID` conversion fails.
    public static func toLexiconValue(from jsonValue: IPLD.JSONValue) throws -> LexiconValue {
        return try Self.toLexiconValue(from: IPLD.jsonToIPLD(jsonValue))
    }

    /// Converts a JSON string to a `LexiconValue` object.
    ///
    /// - Parameter jsonString: The JSON string to convert.
    /// - Returns: The converted `LexiconValue` object.
    ///
    /// - Throws: An error if `CID` conversion fails.
    public static func toLexiconValue(from jsonString: String) throws -> LexiconValue {
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        let json = try decoder.decode(IPLD.JSONValue.self, from: jsonData)

        let ipld = IPLD.jsonToIPLD(json)

        return try Self.toLexiconValue(from: ipld)
    }

}

/// A typealias representing a dictionary of `String` keys to `LexiconValue`s.
public typealias RepositoryRecord = [String: LexiconValue]
