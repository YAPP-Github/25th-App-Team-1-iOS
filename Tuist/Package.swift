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
            "SnapKit": .framework,
            "Lottie": .staticLibrary,
            "Alamofire": .framework,
        ]
    )
#endif

let package = Package(
    name: "Orbit",
    dependencies: [
        .package(url: "https://github.com/uber/RIBs.git", from: "0.16.3"),
        .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "11.2.0"),
        .package(url: "https://github.com/amplitude/Amplitude-Swift.git", from: "1.11.7"),
    ]
)
