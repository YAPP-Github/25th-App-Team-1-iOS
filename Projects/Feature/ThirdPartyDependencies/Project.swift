//
//  Project.swift
//
//  Created by ever on 2025/02/02
//

import ProjectDescription
import DependencyPlugin

let project = Project(
    name: "ThirdPartyDependencies",
    targets: [
        // Feature
        .target(
            name: "FeatureThirdPartyDependencies",
            destinations: .iOS,
            product: .framework,
            bundleId: Project.Environment.bundleId(suffix: "feature.ThirdPartyDependencies"),
            deploymentTargets: Project.Environment.deploymentTarget,
            sources: ["Feature/Sources/**"],
            dependencies: [
                .thirdParty(library: .Lottie),
                .thirdParty(library: .RIBs),
                .thirdParty(library: .SnapKit),
                .thirdParty(library: .Then)
            ]
        ),
    ]
)
