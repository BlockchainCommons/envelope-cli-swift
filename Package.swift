// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "envelope",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/BlockchainCommons/BCSwiftFoundation.git", branch: "master"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/WolfMcNally/WolfBase", from: "4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "EnvelopeTool",
            dependencies: [
                "WolfBase",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "BCFoundation", package: "BCSwiftFoundation")
            ]),
        .testTarget(
            name: "EnvelopeToolTests",
            dependencies: [
                "WolfBase",
                "EnvelopeTool",
                .product(name: "BCFoundation", package: "BCSwiftFoundation")
            ]),
    ]
)
