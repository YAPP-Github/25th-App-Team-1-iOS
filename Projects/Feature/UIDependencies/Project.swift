//
//  Project.swift
//
//  Created by ever on 2025/02/02
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "UIDependencies",
    targets: [
        // Feature
        .target(
            name: "FeatureUIDependencies",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.UIDependencies"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .Resources),
                .feature(implements: .DesignSystem)
            ]
        ),
    ]
)
