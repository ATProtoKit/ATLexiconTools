//
//  ATPermissionType.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-02-11.
//

import Foundation

/// A `permission` type.
public struct ATPermissionType: Codable, Sendable, Equatable {

    /// The type value of the object.
    ///
    /// This will always be `permission`.
    public var type: String { "permission" }

    /// Indicates the resource type which access is being granted to.
    public let resource: String

    /// Public repository write permissions. Optional.
    public let repository: Repository?

    /// Remote API calls via proxying or service token generation. Optional.
    public let rpc: RPC?

    /// Creates an instance of `ATPermissionType`.
    ///
    /// - Parameters:
    ///   - resource: Indicates the resource type which access is being granted to.
    ///   - repository: Public repository write permissions. Optional. Defaults to `nil`.
    ///   - rpc: Remote API calls via proxying or service token generation. Optional. Defaults to `nil`.
    public init(resource: String, repository: Repository? = nil, rpc: RPC? = nil) {
        self.resource = resource
        self.repository = repository
        self.rpc = rpc
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.resource = try container.decode(String.self, forKey: .resource)
        self.repository = try container.decodeIfPresent(ATPermissionType.Repository.self, forKey: .repository)
        self.rpc = try container.decodeIfPresent(ATPermissionType.RPC.self, forKey: .rpc)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.resource, forKey: .resource)
        try container.encodeIfPresent(self.repository, forKey: .repository)
        try container.encodeIfPresent(self.rpc, forKey: .rpc)
    }

    enum CodingKeys: String, CodingKey {
        case resource
        case repository = "repo"
        case rpc
    }

    /// Public repository write permissions.
    public struct Repository: Codable, Sendable, Equatable {

        /// An array of record types in the Namespaced Identifier (NSID) format.
        public let collection: Set<String>

        /// An array of record operation limits.
        public let action: Set<Action>

        /// Record operation actions.
        public enum Action: Codable, Sendable, Equatable {

            /// Indicates the "create" operation.
            case create

            /// Indicates the "update" operation.
            case update

            /// Indicates the "delete" operation.
            case delete
        }
    }

    /// Remote API calls via proxying or service token generation.
    public struct RPC: Codable, Sendable, Equatable {

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
