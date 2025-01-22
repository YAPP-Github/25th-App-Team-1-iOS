//
//  Project.swift
//
//  Created by choijunios on 2025/01/20
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "AlarmMission",
    targets: [
        
        // Example
        .target(
            name: "FeatureAlarmMissionExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .AlarmMission),
            ]
        ),


        // Tests
        .target(
            name: "FeatureAlarmMissionTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.AlarmMission.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .AlarmMission),
            ]
        ),


        // Feature
        .target(
            name: "FeatureAlarmMission",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.AlarmMission"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                
                // Internal
                .feature(implements: .Resources),
                .feature(implements: .DesignSystem),
                
                // Third party
                .thirdParty(library: .RIBs),
                .thirdParty(library: .Then),
                .thirdParty(library: .SnapKit),
                .thirdParty(library: .Lottie),
            ]
        ),
    ]
)
