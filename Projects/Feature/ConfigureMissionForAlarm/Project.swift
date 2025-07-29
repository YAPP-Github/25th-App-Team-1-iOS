//
//  Project.swift
//
//  Created by choijunios on 2025/07/21
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "ConfigureMissionForAlarm",
    targets: [
        
        // Example
        .target(
            name: "FeatureConfigureMissionForAlarmExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.example"),
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .app_plist(with: [
                "UIUserInterfaceStyle": "Light",
                "UISupportedInterfaceOrientations": [
                    "UIInterfaceOrientationPortrait"
                ],
                "CFBundleDisplayName": "오르비 알람 데모",
                "CFBundleShortVersionString": "1.0.5"
            ]),
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .ConfigureMissionForAlarm),
            ]
        ),


        // Tests
        .target(
            name: "FeatureConfigureMissionForAlarmTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.ConfigureMissionForAlarm.tests"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Tests/**"],
            dependencies: [
                .feature(implements: .ConfigureMissionForAlarm),
            ]
        ),


        // Feature
        .target(
            name: "FeatureConfigureMissionForAlarm",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.ConfigureMissionForAlarm"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .UIDependencies),
                .feature(implements: .ThirdPartyDependencies),
                .feature(implements: .AlarmMission),
            ]
        ),
    ],
    schemes: [
        // MARK: Release scheme
        .scheme(
            name: "FeatureConfigureMissionForAlarmExample-Release",
            buildAction: .buildAction(
                targets: [ .target("FeatureConfigureMissionForAlarmExample") ]
            ),
            runAction: .runAction(configuration: "Release"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
