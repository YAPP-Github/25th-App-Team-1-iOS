//
//  Project.swift
//
//  Created by 손병근 on 2025/01/04
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "FeatureOnboarding",
    targets: [
        
        // Example
        .target(
            name: "FeatureOnboardingExample",
            destinations: .iOS,
            product: .app,
            productName: "OrbitOnboardingDemo",
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .app_plist(with: [
                "CFBundleShortVersionString": "1.0.1"
            ]),
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .Onboarding),
                .feature(implements: .ThirdPartyDependencies)
            ],
            settings: .settings(configurations: [
                .debug(name: "Debug"),
                .release(name: "Release")
            ])
        ),


        // Tests
        .target(
            name: "FeatureOnboardingTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.onboarding.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .Onboarding),
            ]
        ),


        // Feature
        .target(
            name: "FeatureOnboarding",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.onBoarding"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .UIDependencies),
                .feature(implements: .CommonDependencies),
                .feature(implements: .ThirdPartyDependencies),
                .feature(implements: .Networking),
                .feature(implements: .Logger),
            ]
        ),
    ],
    schemes: [
        
        // MARK: Debug scheme
        .scheme(
            name: "FeatureOnboardingExample-Debug",
            buildAction: .buildAction(
                targets: [ .target("FeatureOnboardingExample") ]
            ),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Debug")
        ),
        
        // MARK: Release scheme
        .scheme(
            name: "FeatureOnboardingExample-Release",
            buildAction: .buildAction(
                targets: [ .target("FeatureOnboardingExample") ]
            ),
            runAction: .runAction(configuration: "Release"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
