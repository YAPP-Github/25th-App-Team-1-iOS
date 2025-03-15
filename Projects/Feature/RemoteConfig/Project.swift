//
//  Project.swift
//
//  Created by choijunios on 2025/03/15
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "RemoteConfig",
    targets: [

        // Tests
        .target(
            name: "FeatureRemoteConfigTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.RemoteConfig.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .RemoteConfig),
            ]
        ),


        // Feature
        .target(
            name: "FeatureRemoteConfig",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.RemoteConfig"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .thirdParty(library: .FirebaseRemoteConfig),
            ],
            settings: .settings(base: [
                "OTHER_LDFLAGS": "-ObjC"
            ])
        ),
    ]
)
