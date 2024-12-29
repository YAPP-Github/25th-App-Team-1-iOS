// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: ["RIBs": .framework]
    )
#endif

let package = Package(
    name: "Orbit",
    dependencies: [
        
        .package(url: "https://github.com/uber/RIBs.git", from: "0.16.3")
    ]
)
