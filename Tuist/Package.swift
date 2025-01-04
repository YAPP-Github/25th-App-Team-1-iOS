// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [
            "RIBs": .framework,
            "Then": .framework,
            "SnapKit": .framework
        ]
    )
#endif

let package = Package(
    name: "Orbit",
    dependencies: [
        .package(url: "https://github.com/uber/RIBs.git", from: "0.16.3"),
        .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
    ]
)
