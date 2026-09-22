// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "StructuredDesignSystem",
    platforms: [
        .iOS(.v18),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "StructuredDesignSystem",
            targets: ["StructuredDesignSystem"]
        )
    ],
    targets: [
        .target(name: "StructuredDesignSystem"),
        .executableTarget(
            name: "RenderPreviews",
            dependencies: ["StructuredDesignSystem"]
        )
    ]
)
