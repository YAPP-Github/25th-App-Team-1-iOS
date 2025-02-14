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
                "CFBundleDisplayName": "Orbit",
                "CFBundleShortVersionString": "1.0.0",
                "NSPhotoLibraryUsageDescription": "부적 이미지를 저장하기 위해서는 앨범 접근 권한이 필요해요!"
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
//            entitlements: .file(path: .relativeToRoot("Entitlements/App.entitlements")),
            dependencies: [
                // Feature
                .feature(implements: .Onboarding),
                .feature(implements: .Main),
                .feature(implements: .Alarm),
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
