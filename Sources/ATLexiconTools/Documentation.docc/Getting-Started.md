# Getting Started With ATLexiconTools

Learn how to parse, register, and validate AT Protocol Lexicon schemas using ATLexiconTools.

## Overview

Use ``ATLexiconTools`` when you need Swift access to [AT Protocol Lexicons](https://atproto.com/specs/lexicon), which includes parsing schema JSON, registering related definitions, and validating runtime payloads against those schemas.

Most applications follow the same high-level flow:

1. Parse one or more Lexicon documents with ``LexiconParser``.
2. Add them to a ``LexiconRegistry``.
3. Validate records, objects, and XRPC payloads before you persist or transmit them.
4. Use the normalized values returned by validation when you want default values applied.

## Parse a Lexicon

```swift
import ATLexiconTools

let schema = """
        {
          "lexicon": 1,
          "id": "com.example.profile",
          "defs": {
            "main": {
              "$type": "record",
              "record": {
                "$type": "object",
                "required": ["displayName"],
                "properties": {
                  "displayName": { "$type": "string" },
                  "bio": { "$type": "string" }
                }
              }
            }
          }
        }
"""

let lexicon = try LexiconParser.parseLexicon(schema)
```

When you already have multiple schema documents, ``LexiconParser/parseMultipleLexicons(_:keyDecodingStrategy:)`` gives you a convenient batch entry point.

## Build a Registry

```swift
let registry = try LexiconRegistry(lexicons: [lexicon])
```

The registry resolves definitions and reference URIs so you can validate by schema identifier later.

## Validate a Record

```swift
let value = try registry.validateRecord(
    by: "com.example.profile",
    value: .object([
        "$type": "com.example.profile",
        "displayName": "Alice",
        "bio": "Hello from Swift."
    ])
)
```

Validation throws when the payload does not satisfy the Lexicon constraints. On success, the returned ``PrimitiveValue`` is the normalized form of the payload, which is especially useful when your schema provides default values.
