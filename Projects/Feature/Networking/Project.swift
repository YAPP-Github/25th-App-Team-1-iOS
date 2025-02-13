//
//  Project.swift
//
//  Created by ever on 2025/02/13
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Networking",
    targets: [
        // Feature
        .target(
            name: "FeatureNetworking",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.Networking"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .ThirdPartyDependencies),
                .feature(implements: .CommonDependencies)
            ]
        ),
    ]
)
