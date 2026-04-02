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

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
