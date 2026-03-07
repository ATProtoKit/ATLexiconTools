//
//  PermissionSetDefinition.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2026-02-11.
//

import Foundation

/// A primary `permission-set` type definition.
public struct PermissionSetDefinition: ATLexiconObjectProtocol {

    /// The type value of the object.
    ///
    /// This will always be `permission-set`.
    public var type: String = "permission-set"

    /// The user-facing short name of the permission. Optional.
    public let title: String?

    /// A dictionary of the localized user-facing short name of the permission. Optional.
    ///
    /// The key value should be a valid language code.
    public let titleLanguage: [String: String]?

    /// A user-facing description of the permission.
    public let detail: String?

    /// A dictionary of the localized user-facing descriptions of the permission. Optional.
    ///
    /// The key value should be a valid language code.
    public let detailLanguage: [String: String]?

    /// An array of permissions.
    public let permissions: [ATPermissionType]

    /// Creates an instance of `PermissionSetDefinition`.
    ///
    /// - Parameters:
    ///   - title: The user-facing short name of the permission. Optional. Defaults to `nil`.
    ///   - titleLanguage: A user-facing description of the permission. Optional. Defaults to `nil`.
    ///   - detail: A user-facing description of the permission. Optional. Defaults to `nil`.
    ///   - detailLanguage: A dictionary of the localized user-facing descriptions of the permission.
    ///   Optional. Defaults to `nil`.
    ///   - permissions: An array of permissions.
    public init(
        title: String? = nil,
        titleLanguage: [String : String]? = nil,
        detail: String? = nil,
        detailLanguage: [String : String]? = nil,
        permissions: [ATPermissionType]
    ) {
        self.title = title
        self.titleLanguage = titleLanguage
        self.detail = detail
        self.detailLanguage = detailLanguage
        self.permissions = permissions
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.titleLanguage = try container.decodeIfPresent([String : String].self, forKey: .titleLanguage)
        self.detail = try container.decodeIfPresent(String.self, forKey: .detail)
        self.detailLanguage = try container.decodeIfPresent([String : String].self, forKey: .detailLanguage)
        self.permissions = try container.decode([ATPermissionType].self, forKey: .permissions)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.titleLanguage, forKey: .titleLanguage)
        try container.encodeIfPresent(self.detail, forKey: .detail)
        try container.encodeIfPresent(self.detailLanguage, forKey: .detailLanguage)
        try container.encode(self.permissions, forKey: .permissions)
    }

    enum CodingKeys: String, CodingKey {
        case title
        case titleLanguage = "title:lang"
        case detail
        case detailLanguage = "detail:lang"
        case permissions
    }

}
