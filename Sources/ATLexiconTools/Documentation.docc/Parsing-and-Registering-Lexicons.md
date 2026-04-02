# Parsing and Registering Lexicons

## Overview

AT Protocol applications rarely work with a single schema in isolation. A realistic deployment usually has a family of record types, XRPC endpoints, and shared definitions connected by references. ``LexiconParser`` and ``LexiconRegistry`` are the main tools for bringing those documents into memory and validating them as a set.

For background on how Lexicon documents are structured, see the official [Intro to Lexicon](https://atproto.com/guides/lexicon) guide and the [Lexicon specification](https://atproto.com/specs/lexicon).

## Decode Schema JSON

Use ``LexiconParser`` when your source of truth is JSON:

```swift
let lexicons = try LexiconParser.parseMultipleLexicons([
    "{ ... }",
    "{ ... }",
    "{ ... }"
])
```

This converts it into a strongly-typed ``Lexicon`` model for use later on.

## Register a Family of Schemas

Create a ``LexiconRegistry`` from the parsed models:

```swift
let registry = try LexiconRegistry(lexicons: lexicons)
```

The registry is responsible for tracking lexicons by URI. It exposes individual definitions through the method ``LexiconRegistry/getDefinition(by:types:shouldNormalizeURI:)``. Additionally, it resolves and validates references across multiple schema documents. The registry also serves as the validation entry point for runtime data.

## Work with Definitions

Once the registry exists, you can ask for either the whole Lexicon or a specific definition:

```swift
let lexicon = try registry.getLexicon(from: "com.example.profile")
let recordDefinition = try registry.getDefinition(by: "com.example.profile")
let objectDefinition = try registry.getDefinition(by: "com.example.profile#main")
```

This makes the registry useful both at runtime and in developer tooling such as code generation, schema inspection, or custom documentation output.

## Normalize URIs Consistently

AT Protocol Lexicons are identified by NSIDs and definition fragments. ``LexiconToolsUtilities`` contains helpers such as ``LexiconToolsUtilities/toLexiconURI(from:resolvedAgainst:)`` for normalizing those identifiers.

In most application code, prefer using ``LexiconRegistry`` as the abstraction boundary and let it handle the normalization for you.
