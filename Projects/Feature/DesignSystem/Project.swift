import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "FeatureDesignSystem",
    targets: [
        // MARK: Feature module
        .target(
            name: "FeatureDesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.designSystem"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: []
        ),

    ]
)
