//
//  MainComponent+Onboarding.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import FeatureOnboarding
import FeatureLogger

extension MainComponent: FeatureOnboarding.RootDependency {
    var onboardingRootViewController: any FeatureOnboarding.RootViewControllable {
        rootViewController
    }
    var logger: Logger { dependency.logger }
}
