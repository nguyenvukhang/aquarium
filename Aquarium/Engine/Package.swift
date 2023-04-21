// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Engine",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Engine", targets: ["Engine"]),
        .executable(name: "Cli", targets: ["Cli"]),
        .executable(name: "Tests", targets: ["Tests"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Engine", dependencies: []),
        .executableTarget(
            name: "Tests",
            dependencies: ["Engine"],
            path: "Tests",
            exclude: []),
        .executableTarget(
            name: "Cli",
            dependencies: ["Engine"],
            path: "Sources/Cli",
            exclude: [])
    ])
