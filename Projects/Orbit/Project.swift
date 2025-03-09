import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "Orbit",
    targets: [
        .target(
            name: "Orbit",
            destinations: .iOS,
            product: .app,
            bundleId: "com.yaf.orbit",
            deploymentTargets: Project.Environment.deploymentTarget,
            infoPlist: .app_plist(with: [
                "UIUserInterfaceStyle": "Light",
                "UISupportedInterfaceOrientations": [
                    "UIInterfaceOrientationPortrait"
                ],
                "CFBundleDisplayName": "오르비 알람",
                "CFBundleShortVersionString": "1.0.1",
                "NSPhotoLibraryUsageDescription": "부적 이미지를 저장하기 위해서는 앨범 접근 권한이 필요해요!",
                "UIBackgroundModes": [
                    "processing"
                ],
                "BGTaskSchedulerPermittedIdentifiers": [
                    "com.yaf.orbit.checkAndScheduleAlarm"
                ]
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
//            entitlements: .file(path: .relativeToRoot("Entitlements/App.entitlements")),
            dependencies: [
                // Feature
                .feature(implements: .Onboarding),
                .feature(implements: .Main),
                .feature(implements: .Alarm),
                .feature(implements: .AlarmCommon),
                .feature(implements: .AlarmController),
                // Third party
                .feature(implements: .ThirdPartyDependencies)
            ]
        ),
    ],
    schemes: [
        
        // MARK: Debug scheme
        .scheme(
            name: "Orbit-Debug",
            buildAction: .buildAction(
                targets: [ .target("Orbit") ]
            ),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Debug")
        ),
        
        // MARK: Release scheme
        .scheme(
            name: "Orbit-Release",
            buildAction: .buildAction(
                targets: [ .target("Orbit") ]
            ),
            runAction: .runAction(configuration: "Release"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
