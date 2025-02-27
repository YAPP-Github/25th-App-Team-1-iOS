//
//  Project.swift
//
//  Created by ever on 2025/02/10
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "AlarmRelease",
    targets: [
        
        // Example
        .target(
            name: "FeatureAlarmReleaseExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .AlarmRelease),
                .feature(implements: .UIDependencies),
                .feature(implements: .CommonDependencies),
                .feature(implements: .ThirdPartyDependencies)
            ]
        ),


        // Tests
        .target(
            name: "FeatureAlarmReleaseTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.AlarmRelease.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .AlarmRelease),
            ]
        ),


        // Feature
        .target(
            name: "FeatureAlarmRelease",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.AlarmRelease"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .AlarmCommon),
                .feature(implements: .UIDependencies),
                .feature(implements: .CommonDependencies),
                .feature(implements: .ThirdPartyDependencies)
            ]
        ),
    ]
)
