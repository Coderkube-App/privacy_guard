// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "privacy_guard",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "privacy-guard", targets: ["privacy_guard"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "privacy_guard",
            dependencies: [],
            path: "../Classes"
        )
    ]
)
