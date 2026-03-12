// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATLexiconTools",
    platforms: [
        .iOS(.v14),
        .macOS(.v13),
        .tvOS(.v14),
        .visionOS(.v1),
        .watchOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ATLexiconTools",
            targets: ["ATLexiconTools"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ATProtoKit/ATSyntaxTools.git", from: "0.1.0"),
        .package(url: "https://github.com/ATProtoKit/ATCommonTools.git", from: "0.0.10"),
        .package(url: "https://github.com/ATProtoKit/MultiformatsKit.git", from: "0.3.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ATLexiconTools",
            dependencies: [
                .product(name: "ATSyntaxTools", package: "atsyntaxtools"),
                .product(name: "ATCommonWeb", package: "atcommontools")
            ]
        ),
        .testTarget(
            name: "ATLexiconToolsTests",
            dependencies: [
                "ATLexiconTools",
                .product(name: "MultiformatsKit", package: "multiformatskit")
            ]
        ),
    ]
)
