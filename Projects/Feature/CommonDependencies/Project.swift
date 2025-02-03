//
//  Project.swift
//
//  Created by ever on 2025/02/02
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "CommonDependencies",
    targets: [
        // Feature
        .target(
            name: "FeatureCommonDependencies",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.CommonDependencies"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .CommonEntity)
            ]
        ),
    ]
)
