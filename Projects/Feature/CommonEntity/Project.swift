//
//  Project.swift
//
//  Created by 손병근 on 2025/02/01
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "CommonEntity",
    targets: [
        // Feature
        .target(
            name: "FeatureCommonEntity",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.CommonEntity"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .Resources),
            ]
        ),
    ]
)
