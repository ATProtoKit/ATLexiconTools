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
    public let permissions: [String]


    enum CodingKeys: String, CodingKey {
        case title
        case titleLanguage = "title:lang"
        case detail
        case detailLanguage = "detail:lang"
        case permissions
    }

}
