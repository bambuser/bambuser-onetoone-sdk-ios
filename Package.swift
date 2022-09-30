// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "BambuserLiveShoppingOnetoOne",
    platforms: [
        .iOS("14.3")
    ],
    products: [
        .library(
            name: "BambuserLiveShoppingOnetoOne",
            targets: ["BambuserLiveShoppingOnetoOne"])
    ],
    targets: [
        .binaryTarget(
            name: "BambuserLiveShoppingOnetoOne",
            path: "Sources/BambuserLiveShoppingOnetoOne.xcframework")
    ]
)
