// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LucyEngine",
    products: [
        .executable(name: "LucyEngine", targets: ["LucyEngine"]),
        .library(name: "LucyCore", targets: ["LucyCore"])
    ],
    targets: [
        .executableTarget(
            name: "LucyEngine",
            dependencies: ["LucyCore"]),
        .target(
            name: "LucyCore")
    ]
)
