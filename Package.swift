// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "iOSRSAUnretarder",
    platforms: [
       .iOS(.v13),
    ],
    products: [
        .library(
            name: "iOSRSAUnretarder",
            targets: ["iOSRSAUnretarder"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "iOSRSAUnretarder",
            path: "Sources"),
        .testTarget(
            name: "iOSRSAUnretarderTests",
            dependencies: ["iOSRSAUnretarder"]),
    ]
)
