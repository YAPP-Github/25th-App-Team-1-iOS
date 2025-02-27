//
//  Project.swift
//
//  Created by ever on 2025/02/26
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "AlarmCommon",
    targets: [
        // Feature
        .target(
            name: "FeatureAlarmCommon",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.AlarmCommon"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .CommonDependencies),
                .feature(implements: .UIDependencies)
            ]
        ),
    ]
)
