//
//  Project.swift
//
//  Created by choijunios on 2025/03/12
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Logger",
    targets: [

        // Tests
        .target(
            name: "FeatureLoggerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.Logger.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .Logger),
            ]
        ),


        // Feature
        .target(
            name: "FeatureLogger",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.Logger"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: [
                "Feature/Sources/**",
                "../../../Secrets/APIKeys.swift"
            ],
            dependencies: [
                .feature(implements: .ThirdPartyDependencies),
                .thirdParty(library: .AmplitudeSwift),
            ],
            settings: .settings(base: [
                "SWIFT_OPTIMIZATION_LEVEL": "-Onone"
            ])
        ),
    ]
)
