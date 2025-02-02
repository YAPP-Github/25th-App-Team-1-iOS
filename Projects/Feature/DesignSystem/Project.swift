//
//  Project.swift
//
//  Created by ever on 2025/01/07
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "DesignSystem",
    targets: [
        
        // Example
        .target(
            name: "FeatureDesignSystemExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .DesignSystem),
            ]
        ),


        // Tests
        .target(
            name: "FeatureDesignSystemTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.DesignSystem.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .DesignSystem),
            ]
        ),


        // Feature
        .target(
            name: "FeatureDesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.DesignSystem"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .Resources),
                .feature(implements: .CommonDependencies),
                .thirdParty(library: .SnapKit),
                .thirdParty(library: .Then)
            ]
        ),
    ]
)
