import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Orbit",
    targets: [
        .target(
            name: "Orbit",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "app"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .app,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                
                // Third party
                .thirdParty(library: .RIBs)
            ]
        ),
    ]
)
