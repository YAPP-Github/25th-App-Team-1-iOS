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
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .Onboarding),
                .thirdParty(library: .RIBs)
            ]
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
                .feature(implements: .Resources),
                .feature(implements: .DesignSystem),
                .thirdParty(library: .RIBs),
                .thirdParty(library: .SnapKit),
                .thirdParty(library: .Then),
                .thirdParty(library: .Lottie)
            ]
        ),
    ]
)
