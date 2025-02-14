//
//  Project.swift
//
//  Created by choijunios on 2025/02/13
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Setting",
    targets: [
        
        // Example
        .target(
            name: "FeatureSettingExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .Setting),
            ]
        ),


        // Tests
        .target(
            name: "FeatureSettingTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.Setting.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .Setting),
            ]
        ),


        // Feature
        .target(
            name: "FeatureSetting",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.Setting"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .UIDependencies),
                .feature(implements: .ThirdPartyDependencies),
                .feature(implements: .Networking),
            ]
        ),
    ]
)
