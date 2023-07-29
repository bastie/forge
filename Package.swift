// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "forge",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "forge",
            targets: ["forge"]),
    ],
    dependencies: [
            // Here we define our package's external dependencies
            // and from where they can be fetched:
            .package(url: "https://github.com/bastie/egg.git", .upToNextMajor(from: "0.1.2")),
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "forge",
            dependencies: [
                .product(name: "KnightLife", package: "egg"),
            ],
            path: "Sources"),
    ]
)
