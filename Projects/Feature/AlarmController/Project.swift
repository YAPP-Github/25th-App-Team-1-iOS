//
//  Project.swift
//
//  Created by choijunios on 2025/03/09
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "AlarmController",
    targets: [

        // Tests
        .target(
            name: "FeatureAlarmControllerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.AlarmController.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .AlarmController),
            ]
        ),


        // Feature
        .target(
            name: "FeatureAlarmController",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.AlarmController"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            resources: ["Feature/Resources/**"],
            dependencies: [
                .feature(implements: .CommonDependencies),
                .feature(implements: .ThirdPartyDependencies),
            ]
        ),
    ]
)
