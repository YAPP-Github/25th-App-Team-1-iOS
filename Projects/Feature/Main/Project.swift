//
//  Project.swift
//
//  Created by choijunios on 2025/01/27
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Main",
    targets: [
        
        // Example
        .target(
            name: "FeatureMainExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .Main),
            ]
        ),


        // Tests
        .target(
            name: "FeatureMainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.Main.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .Main),
            ]
        ),


        // Feature
        .target(
            name: "FeatureMain",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.Main"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .UIDependencies),
                .feature(implements: .ThirdPartyDependencies),
                .feature(implements: .AlarmCommon),
                .feature(implements: .Alarm),
                .feature(implements: .AlarmMission),
                .feature(implements: .AlarmRelease),
                .feature(implements: .Fortune),
                .feature(implements: .Networking),
                .feature(implements: .Setting),
                .feature(implements: .AlarmController),
            ]
        ),
    ]
)
