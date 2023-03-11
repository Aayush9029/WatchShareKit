// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WatchShareKit",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "WatchShareKit",
            targets: ["WatchShareKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WatchShareKit",
            dependencies: [],
            path: "Sources"),
    ])
