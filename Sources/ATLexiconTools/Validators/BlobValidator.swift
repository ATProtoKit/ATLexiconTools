//
//  BlobValidator.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-08-07.
//


extension Validator.Blob {

    /// Validates a blob reference.
    ///
    /// - Parameters:
    ///   - lexicons: A registry containing an array of lexicons.
    ///   - path: The name of the path.
    ///   - definition: The definition container.
    ///   - value: The specific value to validate. Optional.
    ///
    ///   - Throws: An error if the blob reference is invalid.
    public static func validateBlob(
        in lexicons: LexiconRegistry,
        at path: String,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws {
        guard let value, case .blob = value else {
            throw LexiconValidatorError.invalidBlobReferencePath(path: path)
        }
    }
}
