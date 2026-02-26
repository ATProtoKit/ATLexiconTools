//
//  BlobValidator.swift
//  ATLexiconTools
//
//  Created by Christopher Jr Riley on 2025-08-07.
//


extension Validator.Blob {

    public static func validateBlob(
        in lexicons: LexiconRegistry,
        at path: String,
        definition: LexiconDefinition,
        value: PrimitiveValue?
    ) throws -> PrimitiveValue {
        guard let value, case .blob = value else {
            throw LexiconValidatorError.invalidBlobReferencePath(path: path)
        }

        return value
    }
}
