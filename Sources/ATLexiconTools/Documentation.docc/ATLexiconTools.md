# ``ATLexiconTools``

@Metadata {
    @PageImage(
               purpose: icon, 
               source: "atlexicontools_icon", 
               alt: "A technology icon representing the ATLexiconTools framework.")
    @PageColor(blue)
}

Parse, model, and validate AT Protocol Lexicons in Swift.

## Overview

AT Protocol uses [Lexicon](https://atproto.com/specs/lexicon) as its schema language for repository records, XRPC endpoints, and subscription messages. ``ATLexiconTools`` brings that model into Swift so you can:

- Parse Lexicon JSON into strongly-typed Swift models.
- Build schema definitions directly in code.
- Register schemas and resolve references across a collection of Lexicons.
- Validate records, objects, query parameters, request bodies, and response bodies.
- Work with AT Protocol-specific values such as blobs, CIDs, and IPLD-backed data.

If you are new to Lexicon itself, the official [Intro to Lexicon](https://atproto.com/guides/lexicon) guide is a good companion to these docs, and the [Lexicon specification](https://atproto.com/specs/lexicon) defines the full schema language used by this package.

This library works best with ATProtoKit and the rest of the famiy of Swift packages related to the project. However, you are also free to use other atproto Swift packages that might not be related to ATProtoKit.

The package fully open sourced and is licenced under the Apache 2.0 licence. You can take a look at it and make contribitions to it on [GitHub](https://github.com/ATProtoKit/ATLexiconTools). The Swift code has been converted from the official TypeScript code in the AT Protocol's [lexicon package](https://github.com/bluesky-social/atproto/tree/main/packages/lexicon), but written in a type-safe way without sacrificing speed.

## Topics

### Essentials

- <doc:Getting-Started>
- <doc:Parsing-and-Registering-Lexicons>
- ``LexiconParser``
- ``LexiconRegistry``
- ``Lexicon``
- ``PrimitiveValue``
- ``LexiconValue``

### Primary Lexicon Definitions

- ``LexiconDefinition``
- ``RecordDefinition``
- ``QueryDefinition``
- ``ProcedureDefinition``
- ``SubscriptionDefinition``
- ``PermissionSetDefinition``
- ``LexiconHTTPBody``

### Schema and Field Types

- ``ATArrayType``
- ``ATBlobType``
- ``ATBooleanType``
- ``ATBytesType``
- ``ATCIDLinkType``
- ``ATErrorsType``
- ``ATIntegerType``
- ``ATObjectType``
- ``ATParamsType``
- ``ATReferenceType``
- ``ATStringType``
- ``ATTokenType``
- ``ATUnionType``
- ``ATUnknownType``
- ``ATPermissionType``

### Serialization

- <doc:Working-with-Blob-References-and-Lexicon-Values>
- ``RepositoryRecord``
- ``ATLexiconPrimitive``
- ``ATPrimitiveArray``
- ``ATLexiconIPLDType``
- ``ATLexiconReferenceVariant``
- ``ATLexiconSubscriptionMessage``

### Validation and Support

- ``Validator``
- ``LexiconToolsUtilities``
- ``ATLexiconObjectProtocol``

### Errors

- ``LexiconToolsError``
- ``LexiconRegistryError``
- ``LexiconValidatorError``
- ``LexiconSchemaValidatorError``
- ``BlobReferenceConversionError``
