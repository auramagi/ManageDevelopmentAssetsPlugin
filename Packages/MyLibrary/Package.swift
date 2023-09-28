// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "MyLibrary",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "MyLibrary",
            targets: ["MyLibrary"]),
    ],
    targets: [
        .plugin(
            name: "ManageDevelopmentAssetsPlugin",
            capability: .buildTool()
        ),
        .target(
            name: "MyLibrary",
            dependencies: ["PreviewAssets"]
        ),
        .target(
            name: "PreviewAssets",
            exclude: [
                "Assets.development.xcassets",
                "Content.development",
            ],
            resources: [
                .process("Content"),
            ],
            plugins: [
                .plugin(name: "ManageDevelopmentAssetsPlugin"),
            ]
        ),
    ]
)
