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
                "CFBundleShortVersionString": "1.0.2",
                "NSPhotoLibraryUsageDescription": "부적 이미지를 저장하기 위해서는 앨범 접근 권한이 필요해요!",
                "UIBackgroundModes": [
                    "processing", "audio"
                ],
                "BGTaskSchedulerPermittedIdentifiers": [
                    "com.yaf.orbit.checkAndScheduleAlarm",
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
                .feature(implements: .AlarmController),
                .feature(implements: .RemoteConfig),
                
                // Third party
                .feature(implements: .ThirdPartyDependencies),
            ],
            settings: .settings(
                base: [
                    "AMPLITUDE_API_KEY": "$(AMPLITUDE_API_KEY)"
                ],
                configurations: [
                    .debug(
                        name: "Debug",
                        xcconfig: .relativeToRoot("Secrets/xcconfigs/Debug.xcconfig")
                    ),
                    .release(
                        name: "Release",
                        xcconfig: .relativeToRoot("Secrets/xcconfigs/Release.xcconfig")
                    ),
            ])
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
            runAction: .runAction(
                configuration: "Release",
                arguments: .arguments(environmentVariables: [
                    "AMPLITUDE_API_KEY": "$(AMPLITUDE_API_KEY)"
                ])
            ),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
