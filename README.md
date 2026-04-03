<p align="center">
  <img src="https://github.com/ATProtoKit/ATLexiconTools/blob/main/Sources/ATLexiconTools/Documentation.docc/Resources/atlexicontools_icon.png" height="128" alt="An icon for ATLexiconTools, which contains three stacks of rounded rectangles in an isometric top view. At the top stack, there's an at symbol in a thick weight, with a pointed arrow at the tip. The at symbol is inside of an orange puzzle piece, which is on top of a red background. The three stacks are, from top to bottom, red, orange, and blue.">
</p>

<h1 align="center">ATLexiconTools</h1>

<p align="center">Lexicon utilities for the AT Protocol, written in Swift.</p>

<div align="center">

[![GitHub Repo stars](https://img.shields.io/github/stars/ATProtoKit/ATLexiconTools?style=flat&logo=GitHub)](https://github.com/ATProtoKit/ATLexiconTools)

</div>
<div align="center">

[![Static Badge](https://img.shields.io/badge/Follow-%40cjrriley.ca-0073fa?style=flat&logo=bluesky&labelColor=%23151e27&link=https%3A%2F%2Fbsky.app%2Fprofile%2Fcjrriley.ca)](https://bsky.app/profile/cjrriley.ca)
[![GitHub Sponsors](https://img.shields.io/github/sponsors/masterj93?color=%23cb5f96&link=https%3A%2F%2Fgithub.com%2Fsponsors%2FMasterJ93)](https://github.com/sponsors/MasterJ93)

</div>

ATLexiconTools is a Swift package for parsing, modeling, and validating AT Protocol Lexicons. It helps you work with repository records, XRPC endpoints, and subscription messages using strongly typed Swift structures instead of raw JSON.

The package is designed to make schema-aware development easier by letting you define Lexicons in code, register and resolve schema references, and validat erecords, query parameters, and request or response payloads against the AT Protocol specifications.

This Swift package mainly focuses on the syntax validation side of the AT Protocol. This is based on the [`lexicon`](https://github.com/bluesky-social/atproto/tree/main/packages/lexicon) package from the official [`atproto`](https://github.com/bluesky-social/atproto) TypeScript repository.

## Quick Example

```swift
import ATLexiconTools

do {
    let schema = """
            {
                "lexicon": 1,
                "id": "com.example.kitchenSink",
                "defs": {
                    // ...
                }
            }
            """

    let lexicon = try LexiconParser.parseLexicon(schema)
    let registry = try LexiconRegistry(lexicons: [lexicon])
    
    _ = try registry.validateRecord(by: "com.example.profile", value: .object(["$type": "com.example.profile", ...])
    _ = try registry.validateXRPCParameters(by: "com.example.query", value: ...)
    _ = try registry.validateXRPCInput(by: "com.example.procedure", value: ...)
    _ = try registry.validateXRPCOutput(by: "com.example.query", value: ...)
)
} catch {
    print(error)
}
```

## Requirements

To use ATLexiconTools in your apps, your app should target the specific version numbers:

- **iOS** and **iPadOS** 15 or later.
- **macOS** 13 or later.
- **tvOS** 14 or later.
- **visionOS** 1 or later.
- **watchOS** 9 or later.

On Linux, the minimum requirements include:

- **Amazon Linux** 2
- **Debian** 12
- **Fedora** 39
- **Red Hat UBI** 9
- **Ubuntu** 20.04

For Android, you'll need Swift 6.1 or later. On Android, the minimum requirements include:
- **Android** 10 or later.
- **Android SDK** version 29 or later.

At the moment, Android is in its experimental phase. Plans to take it out of this phase will require testing all parts of the package.

You can also use this project for any programs you make using Swift and running on **Docker**.

## Submitting Contributions and Feedback

While this project will change significantly, feedback, issues, and contributions are highly welcomed and encouraged. If you'd like to contribute to this project, please be sure to read both the [API Guidelines](https://github.com/MasterJ93/ATProtoKit/blob/main/API_GUIDELINES.md) as well as the [Contributor Guidelines](https://github.com/MasterJ93/ATProtoKit/blob/main/CONTRIBUTING.md) before submitting a pull request. Any issues (such as bug reports or feedback) can be submitted in the [Issues](https://github.com/ATProtoKit/ATLexiconTools/issues) tab. Finally, if there are any security vulnerabilities, please read [SECURITY.md](https://github.com/ATProtoKit/ATSyntaxTools/blob/main/SECURITY.md) for how to report it.

If you have any questions, you can ask me on Bluesky ([@cjrriley.ca](https://bsky.app/profile/cjrriley.ca)). And while you're at it, give me a follow! I'm also active on the [Bluesky API Touchers](https://discord.gg/3srmDsHSZJ) Discord server.

## License

This Swift package is using the Apache 2.0 License. Please view [LICENSE.md](https://github.com/ATProtoKit/ATLexiconTools/blob/main/LICENSE.md) for more details.
