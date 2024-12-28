import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "FeatureRoot",
    targets: [
        
        // MARK: Example app
        .target(
            name: "FeatureRootExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.root.example"),
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                
                .feature(implements: .Root)
            ]
        ),
        
        
        // MARK: Unit tests
        .target(
            name: "FeatureRootTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.root.tests"),
            sources: ["Tests/**"],
            dependencies: [
                
                .feature(implements: .Root)
            ]
        ),
        
        
        // MARK: Feature module
        .target(
            name: "FeatureRoot",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.root"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                
                // Third party
                .thirdParty(library: .RIBs)
            ]
        ),

    ]
)
