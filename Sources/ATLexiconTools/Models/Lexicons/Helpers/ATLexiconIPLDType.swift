//
//  ATLexiconIPLDType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A group of IPLD types.
public enum ATLexiconIPLDType: Codable {

    /// The IPLD type is a bytes type.
    case bytes(ATBytesType)

    /// The IPLD type is a CID-Link.
    case cidLink(ATCIDLinkType)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
            case "bytes":
                self = .bytes(try ATBytesType(from: decoder))
            case "cid-link":
                self = .cidLink(try ATCIDLinkType(from: decoder))
            default:
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unsupported IPLD type: \(type)."
                    )
                )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
            case .bytes(let value):
                try container.encode(value)
            case .cidLink(let value):
                try container.encode(value)
        }
    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
    }
}
