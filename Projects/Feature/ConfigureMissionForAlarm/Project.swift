//
//  Project.swift
//
//  Created by choijunios on 2025/07/21
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "ConfigureMissionForAlarm",
    targets: [
        
        // Example
        .target(
            name: "FeatureConfigureMissionForAlarmExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .ConfigureMissionForAlarm),
            ]
        ),


        // Tests
        .target(
            name: "FeatureConfigureMissionForAlarmTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.ConfigureMissionForAlarm.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .ConfigureMissionForAlarm),
            ]
        ),


        // Feature
        .target(
            name: "FeatureConfigureMissionForAlarm",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.ConfigureMissionForAlarm"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .UIDependencies),
                .feature(implements: .ThirdPartyDependencies),
            ]
        ),
    ]
)
