import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "FeatureResources",
    targets: [
        // MARK: Feature module
        .target(
            name: "FeatureResources",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.resources"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .resources,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: []
        ),

    ]
)
