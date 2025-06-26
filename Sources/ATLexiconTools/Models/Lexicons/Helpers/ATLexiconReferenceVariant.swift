//
//  ATLexiconReferenceVariant.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-06-26.
//

import Foundation

/// A group of reference variants.
public enum ATLexiconReferenceVariant: Codable {

    /// The reference variant is a normal reference.
    case reference(ATReferenceType)

    /// The reference variant is a union.
    case union(ATUnionType)

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
            case "ref":
                self = .reference(try ATReferenceType(from: decoder))
            case "union":
                self = .union(try ATUnionType(from: decoder))
            default:
                throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: decoder.codingPath,
                        debugDescription: "Unsupported reference variant: \(type)."
                    )
                )

        }
    }

    public func encode(to encoder: Encoder) throws {

    }

    enum CodingKeys: String, CodingKey {
        case type = "$type"
    }
}
