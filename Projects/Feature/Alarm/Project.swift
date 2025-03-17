import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "FeatureAlarm",
    targets: [
        
        // MARK: Example app
        .target(
            name: "FeatureAlarmExample",
            destinations: .iOS,
            product: .app,
            bundleId: Project.Environment.bundleId(suffix: "feature.alarm.example"),
            infoPlist: .example_app,
            sources: ["Example/Sources/**"],
            resources: ["Example/Resources/**"],
            dependencies: [
                .feature(implements: .UIDependencies),
                .feature(implements: .ThirdPartyDependencies),
                .feature(implements: .Alarm)
            ]
        ),
        
        
        // MARK: Unit tests
        .target(
            name: "FeatureAlarmTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: Project.Environment.bundleId(suffix: "feature.alarm.tests"),
            sources: ["Tests/**"],
            dependencies: [
                
                .feature(implements: .Alarm)
            ]
        ),
        
        
        // MARK: Feature module
        .target(
            name: "FeatureAlarm",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: Project.Environment.bundleId(suffix: "feature.alarm"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .feature(implements: .UIDependencies),
                .feature(implements: .AlarmCommon),
                .feature(implements: .ThirdPartyDependencies),
                .feature(implements: .Logger),
            ]
        ),

    ]
)
