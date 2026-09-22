// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AuraDesignSystem",
    platforms: [
        .iOS(.v18),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "AuraDesignSystem",
            targets: ["AuraDesignSystem"]
        )
    ],
    targets: [
        .target(name: "AuraDesignSystem"),
        .executableTarget(
            name: "RenderPreviews",
            dependencies: ["AuraDesignSystem"]
        )
    ]
)
