// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LucyEngine",
    products: [
        .executable(name: "LucyEngine", targets: ["LucyEngine"]),
        .library(name: "LucyCore", targets: ["LucyCore"])
    ],
    dependencies: [
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "LucyEngine",
            dependencies: ["LucyCore"]),
        .target(
            name: "LucyCore")
    ]
)
