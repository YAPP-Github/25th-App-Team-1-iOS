//
//  MainBuilder.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import FeatureOnboarding

protocol MainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainComponent: Component<MainDependency> {
    let viewController: FeatureOnboarding.RootViewControllable
    init(
        dependency: MainDependency,
        viewController: FeatureOnboarding.RootViewControllable
    ) {
        self.viewController = viewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol MainBuildable: Buildable {
    func build() -> LaunchRouting
}

final class MainBuilder: Builder<MainDependency>, MainBuildable {

    override init(dependency: MainDependency) {
        super.init(dependency: dependency)
    }

    func build() -> LaunchRouting {
        let viewController = MainViewController()
        let component = MainComponent(dependency: dependency, viewController: viewController)
        
        let interactor = MainInteractor(presenter: viewController)
        let onboardingBuilder = FeatureOnboarding.RootBuilder(dependency: component)
        return MainRouter(
            interactor: interactor,
            viewController: viewController,
            onboardingBuilder: onboardingBuilder
        )
    }
}
