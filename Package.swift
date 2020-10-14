// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "M13ProgressSuite",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "M13ProgressSuite",
            targets: ["M13ProgressSuite"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "M13ProgressSuite",
            path: "Classes",
            sources: [
                "Application",
                "Console",
                "HUD",
                "NavigationController",
                "ProgressViews",
            ],
            publicHeadersPath: ""
        ),
    ]
)
