//
//  BlobReferences.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation
import MultiformatsKit
import ATCommonWeb

/// A typed version of the blob reference JSON.
///
/// This version includes a size property, as well as a `CID` object.
public struct TypedJSONBlobReference: Codable, Sendable {

    /// The reference type.
    ///
    /// It will always say "`blob`".
    public let type: String = "blob"

    /// The CID of the blob.
    public let reference: CID

    /// The mime type of the blob.
    public let mimeType: String

    /// The blob's size.
    public let size: Int

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case reference = "ref"
        case mimeType
        case size
    }
}

/// An untyped version of the blob reference JSON.
///
/// This version lacks a size property, as well as a CID in its string representation.
public struct UntypedJSONBlobReference: Codable, Sendable {

    /// The CID of the blob.
    public let cid: String

    /// The mime type of the blob.
    public let mimeType: String
}

/// An enumeration that can represent either a typed or untyped JSON blob reference.
public enum JSONBlobReference: Codable, Sendable {

    /// A typed blob reference.
    case typed(TypedJSONBlobReference)

    /// An untyped blob reference.
    case untyped(UntypedJSONBlobReference)

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(TypedJSONBlobReference.self) {
            self = .typed(value)
        } else if let value = try? container.decode(UntypedJSONBlobReference.self) {
            self = .untyped(value)
        } else {
            throw DecodingError.typeMismatch(
                JSONBlobReference.self, DecodingError.Context(
                    codingPath: decoder.codingPath, debugDescription: "Failed to decode the blob reference."))
        }
    }

    enum CodingKeys: String, CodingKey {
        case typed
        case untyped
    }
}

/// A structure representing a blob reference.
public struct BlobReference: Codable {

    /// The reference type.
    ///
    /// It will always say "`blob`".
    public let type: String = "blob"

    /// The CID of the blob.
    public let reference: CID

    /// The mime type of the blob.
    public let mimeType: String

    /// The blob's size.
    public let size: Int

    /// Initializes an instance of `BlobReference`.
    ///
    /// - Parameters:
    ///   - reference: The `CID` of the blob.
    ///   - mimeType: The MIME type of the blob.
    ///   - size: The size of the blob, in bytes.
    public init(reference: CID, mimeType: String, size: Int) {
        self.reference = reference
        self.mimeType = mimeType
        self.size = size
    }

    /// Initializes a `BlobReference` from an `IPLD.IPLDValue`.
    ///
    /// - Parameter ipldValue: An `IPLD.IPLDValue` that must match the blob schema.
    /// 
    /// - Throws: A `BlobReferenceConversionError` if the structure is invalid.
    public init(from ipldValue: IPLD.IPLDValue) throws {
        // Ensure it's a dictionary.
        guard case let .dictionary(dictionary) = ipldValue else {
            throw BlobReferenceConversionError.invalidStructure
        }

        // Validate "$type" == "blob."
        guard
            let type = dictionary["$type"],
            case let .jsonValue(.string(typeValue)) = type,
            typeValue == "blob" else {
            throw BlobReferenceConversionError.missingOrInvalidField(field: "$type")
        }

        // Get the "ref" field and extract "$link."
        guard let reference = dictionary["ref"],
              case let .dictionary(referenceDictionary) = reference,
              let linkValue = referenceDictionary["$link"],
              case let .jsonValue(.string(linkType)) = linkValue else {
            throw BlobReferenceConversionError.missingOrInvalidField(field: "ref.$link")
        }

        // Decode CID.
        guard let cid = try? CID(string: linkType) else {
            throw BlobReferenceConversionError.invalidCID(cidString: linkType)
        }

        // Get "mimeType."
        guard let mime = dictionary["mimeType"],
              case let .jsonValue(.string(mimeType)) = mime else {
            throw BlobReferenceConversionError.missingOrInvalidField(field: "mimeType")
        }

        // Get "size."
        guard let size = dictionary["size"],
              case let .jsonValue(.number(sizeValue)) = size else {
            throw BlobReferenceConversionError.missingOrInvalidField(field: "size")
        }

        self.init(reference: cid, mimeType: mimeType, size: sizeValue)
    }

    /// Converts a `JSONBlobReference` (either typed or untyped) into a `BlobReference`.
    ///
    /// - Parameter jsonReference: The `JSONBlobReference` value to convert.
    /// - Returns: A new instance of `BlobReference`.
    ///
    /// - Throws: An error if `CID` conversion fails.
    public static func convertToBlobReference(from jsonReference: JSONBlobReference) throws -> BlobReference {
        switch jsonReference {
            case .typed(let typedJSONBlobReference):
                return BlobReference(
                    reference: typedJSONBlobReference.reference,
                    mimeType: typedJSONBlobReference.mimeType,
                    size: typedJSONBlobReference.size
                )
            case .untyped(let untypedJSONBlobReference):
                return BlobReference(
                    reference: try CID(string: untypedJSONBlobReference.cid),
                    mimeType: untypedJSONBlobReference.mimeType,
                    size: -1
                )
        }
    }

    /// Converts this `BlobReference` object to an IPLD-compatible representation.
    ///
    /// - Returns: An `EncodableBlobReference` object that matches the IPLD blob schema.
    ///
    /// - Throws: An error if the `CID` cannot be converted to its canonical string.
    public func toIPLDRepresentation() throws -> EncodableBlobReference {
        let blobLink = try BlobLink(self.reference)

        return EncodableBlobReference(
            reference: blobLink,
            mimeType: self.mimeType,
            size: self.size
        )
    }

    /// Serializes this blob reference to a formatted JSON string.
    ///
    /// - Returns: A JSON string representation of the blob reference.
    ///
    /// - Throws: An error if encoding fails.
    public func toJSONRepresentation() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let encodable = try self.toIPLDRepresentation()
        let jsonData = try encoder.encode(encodable)

        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw EncodingError.invalidValue(
                jsonData,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Could not convert IPLD representation of BlobReference to JSON."
                )
            )
        }

        return jsonString
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case reference = "ref"
        case mimeType
        case size
    }
}

/// A structure that models the IPLD-compatible representation of a blob reference.
public struct EncodableBlobReference: Codable {

    /// The reference type.
    ///
    /// This will always have the value "`blob`".
    public let type: String = "blob"

    /// The wrapped content identifier, encoded as a `$link` property.
    public let reference: BlobLink

    /// The MIME type of the blob.
    public let mimeType: String

    /// The size of the blob, in bytes.
    public let size: Int

    /// Initializes a new `EncodableBlobReference` with the specified values.
    ///
    /// - Parameters:
    ///   - reference: The blob's link (as a `BlobLink` struct).
    ///   - mimeType: The MIME type of the blob.
    ///   - size: The size of the blob, in bytes.
    public init(reference: BlobLink, mimeType: String, size: Int) {
        self.reference = reference
        self.mimeType = mimeType
        self.size = size
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case reference = "ref"
        case mimeType
        case size
    }
}

/// A container that wraps the `$link` property inside of the blob structure.
public struct BlobLink: Codable {

    /// The `$link` property itself.
    public let link: String

    /// Initializes an instance of `BlobLink`.
    ///
    /// - Parameter cid: The `CID` object to extract.
    ///
    /// - Throws: An error if CID conversion to its string representation fails.
    public init(_ cid: CID) throws {
        self.link = try cid.canonicalString
    }

    enum CodingKeys: String, CodingKey {
        case link = "$link"
    }
}
