// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "SwiftApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "App",
            targets: ["App"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: []
        )
    ]
)
