# ``ATLexiconTools``

Parse, model, and validate AT Protocol Lexicons in Swift.

## Overview

AT Protocol uses [Lexicon](https://atproto.com/specs/lexicon) as its schema language for repository records, XRPC endpoints, and subscription messages. ``ATLexiconTools`` brings that model into Swift so you can:

- Parse Lexicon JSON into strongly-typed Swift models.
- Build schema definitions directly in code.
- Register schemas and resolve references across a collection of Lexicons.
- Validate records, objects, query parameters, request bodies, and response bodies.
- Work with AT Protocol-specific values such as blobs, CIDs, and IPLD-backed data.

If you are new to Lexicon itself, the official [Intro to Lexicon](https://atproto.com/guides/lexicon) guide is a good companion to these docs, and the [Lexicon specification](https://atproto.com/specs/lexicon) defines the full schema language used by this package.

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
