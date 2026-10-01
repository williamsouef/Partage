// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PartageCore",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [.library(name: "PartageCore", targets: ["PartageCore"])],
    targets: [
        .target(name: "PartageCore"),
        .testTarget(name: "PartageCoreTests", dependencies: ["PartageCore"]),
    ]
)
