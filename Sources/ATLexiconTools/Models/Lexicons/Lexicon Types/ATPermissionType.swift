//
//  ATPermissionType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-02-11.
//

import Foundation

/// A `permission` type.
public struct ATPermissionType: Codable, Sendable {

    /// The type value of the object.
    ///
    /// This will always be `permission`.
    public var type: String { "permission" }

    /// Indicates the resource type which access is being granted to.
    public let resource: String

    /// Public repository write permissions. Optional.
    public let repository: Repository?

    /// Remote API calls via proxying or service token generation.
    public let rpc: RPC?

    enum CodingKeys: String, CodingKey {
        case resource
        case repository = "repo"
        case rpc
    }

    /// Public repository write permissions.
    public struct Repository: Codable, Sendable {

        /// An array of record types in the Namespaced Identifier (NSID) format.
        public let collection: Set<String>

        /// An array of record operation limits.
        public let action: Set<Action>

        /// Record operation actions.
        public enum Action: Codable, Sendable {

            /// Indicates the "create" operation.
            case create

            /// Indicates the "update" operation.
            case update

            /// Indicates the "delete" operation.
            case delete
        }
    }

    /// Remote API calls via proxying or service token generation.
    public struct RPC: Codable, Sendable {

        /// An array of lexicons related to the RPC.
        ///
        /// - Note: "`*`" is not allowed as a value.
        public let lexicons: [String]

        /// The remote service of the RPC. Optional.
        ///
        /// - Warning: If ``isAudienceInherited`` is set to `true`, then this property must contain
        /// a value.
        public let audience: String?

        /// Determines whether the audience is inherited. Optional.
        ///
        /// If set to `true`, then ``audience`` *must* be filled out.
        public let isAudienceInherited: Bool?

    }
}
