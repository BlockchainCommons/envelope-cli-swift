// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "envelope",
    platforms: [
        .macOS(.v13),
        .macCatalyst(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/BlockchainCommons/BCSwiftFoundation.git", from: "8.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/WolfMcNally/WolfBase", from: "5.0.0"),
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
