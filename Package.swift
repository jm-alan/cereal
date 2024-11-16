// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "Cereal",
    platforms: [.macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Cereal",
            targets: ["Cereal"]
        ),
        .executable(
            name: "CerealClient",
            targets: ["CerealClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.1"),
        .package(url: "https://github.com/swift-extras/swift-extras-json.git", .upToNextMajor(from: "0.6.0")),
    ],
    targets: [
        .macro(
            name: "CerealMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "Cereal", dependencies: ["CerealMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(
            name: "CerealClient",
            dependencies: [
                "Cereal",
                .product(name: "ExtrasJSON", package: "swift-extras-json"),
            ]
        ),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "CerealTests",
            dependencies: [
                "CerealMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
