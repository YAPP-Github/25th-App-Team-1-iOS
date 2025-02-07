//
//  Project.swift
//
//  Created by ever on 2025/02/08
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Fortune",
    targets: [
        
        // Example
        .target(
            name: "FeatureFortuneExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .Fortune),
                .feature(implements: .ThirdPartyDependencies)
            ]
        ),


        // Tests
        .target(
            name: "FeatureFortuneTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.Fortune.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .Fortune),
            ]
        ),


        // Feature
        .target(
            name: "FeatureFortune",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.Fortune"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .UIDependencies),
                .feature(implements: .CommonDependencies),
                .feature(implements: .ThirdPartyDependencies),
            ]
        ),
    ]
)
