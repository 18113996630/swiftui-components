// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "StructuredDesignSystem",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "StructuredDesignSystem",
            targets: ["StructuredDesignSystem"]
        )
    ],
    targets: [
        .target(name: "StructuredDesignSystem")
    ]
)
