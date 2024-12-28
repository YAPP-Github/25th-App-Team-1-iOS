import ProjectDescription

let project = Project(
    name: "Orbit",
    targets: [
        .target(
            name: "Orbit",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Orbit",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Orbit/Sources/**"],
            resources: ["Orbit/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "OrbitTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.OrbitTests",
            infoPlist: .default,
            sources: ["Orbit/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Orbit")]
        ),
    ]
)
