// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSFeatureNammaShopMock",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "NSFeatureNammaShopMock",
            targets: ["NSFeatureNammaShopMock"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/simplex-tech-apps/ns-core-design-system.git",
            from: "1.2.0"
        )
    ],
    targets: [
        .target(
            name: "NSFeatureNammaShopMock",
            dependencies: [
                .product(name: "NammaAppUI", package: "ns-core-design-system")
            ]
        )
    ]
)
