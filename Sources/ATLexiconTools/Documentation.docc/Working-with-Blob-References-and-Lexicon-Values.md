# Working with Blob References and Lexicon Values

@Metadata {
    @TitleHeading("Article")
}

Work with blob references and lexicon values to convert AT Protocol data between JSON transport, validation, and IPLD repository storage.

## Overview

AT Protocol data is not limited to plain strings and integers. Records frequently contain structured values such as blob references, CIDs, JSON-compatible objects, and IPLD-backed representations. ATLexiconTools provides models for these cases so validated payloads can move cleanly between application code and the wider AT Protocol data model.

For background on how records are represented in JSON and CBOR, see the official [Data Model specification](https://atproto.com/specs/data-model).

## Blob References

Use ``BlobReference`` when working with blobs stored in repositories or transmitted through XRPC payloads. It provides a strongly typed representation that preserves the CID, MIME type, and declared size.

```swift
import MultiformatsKit

let blob = try BlobReference(
    reference: CID(string: "bafyreidfayvfuwqa7qlnopdjiqrxzs6blmoeu4rujcjtnci5beludirz2a"),
    mimeType: "image/png",
    size: 2048
)
```

Depending on where the value is headed next, you can convert it into the representation expected by that layer.

- Call ``BlobReference/toJSONRepresentation()`` before sending the value across XRPC boundaries or embedding it inside JSON-facing structures.
- Call ``BlobReference/toIPLDRepresentation()`` when preparing values for repository storage or DAG-CBOR encoding.
- Use ``BlobReference/init(from:)-(Decoder)`` when decoding repository-backed data into a typed Swift model.

Supporting types such as ``JSONBlobReference``, ``TypedJSONBlobReference``, ``UntypedJSONBlobReference``, ``EncodableBlobReference``, and ``BlobLink`` are available when working closer to intermediate serialization steps.

## Primitive Runtime Values

``PrimitiveValue`` is the value representation used internally by the validator registry. Any record, object, or XRPC payload that passes through validation is normalized into this structure.

Because it conforms to Swift literal protocols, values can be constructed inline without introducing additional wrapper types:

```swift
let value: PrimitiveValue = .object([
    "$type": "com.example.profile",
    "displayName": "Alice",
    "tags": ["swift", "atproto"]
])
```

In practice, ``PrimitiveValue`` appears most often while preparing payloads for validation or inspecting the normalized result returned by the registry. It is also a convenient format for schema-level tests because it mirrors the structure the validator itself operates on.

If your code interacts directly with registry validation boundaries, this is the type that will pass through those layers.

## Higher-Level Value Conversion

``LexiconValue`` becomes relevant when values need to move between JSON-style structures and IPLD-style structures without losing AT Protocol–specific semantics such as blob references.

This commonly happens when working with repository records, serialization pipelines, or tooling that sits between validator output and storage encoding.

Several entry points support these transitions:

- ``LexiconValue/toIPLD(from:)`` prepares values for repository storage.
- ``LexiconValue/toJSONValue(from:)`` produces transport-safe JSON-compatible output.
- ``LexiconValue/stringify(_:)`` generates stable string representations.
- ``LexiconValue/toLexiconValue(from:)-(IPLD.IPLDValue)`` reconstructs structured values from IPLD data.

`LexiconValue` effectively sits between validator output and repository serialization, allowing conversions to happen without flattening structured protocol values into ordinary JSON dictionaries.

## Topics

### Blob References

- ``BlobReference``
- ``JSONBlobReference``
- ``TypedJSONBlobReference``
- ``UntypedJSONBlobReference``

### IPLD Support

- ``EncodableBlobReference``
- ``BlobLink``
