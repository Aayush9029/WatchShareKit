// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WatchShareKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "WatchShareKit",
            targets: ["WatchShareKit"]),
        .executable(
            name: "WatchShareKitMacDemo",
            targets: ["WatchShareKitMacDemo"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WatchShareKit",
            dependencies: [],
            path: "Sources/WatchShareKit"),
        .executableTarget(
            name: "WatchShareKitMacDemo",
            dependencies: ["WatchShareKit"],
            path: "Sources/WatchShareKitMacDemo"),
        .testTarget(
            name: "WatchShareKitTests",
            dependencies: ["WatchShareKit"]),
    ])
