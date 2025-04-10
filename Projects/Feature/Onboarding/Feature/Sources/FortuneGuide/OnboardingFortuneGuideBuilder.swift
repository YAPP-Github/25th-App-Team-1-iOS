//
//  OnboardingFortuneGuideBuilder.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import FeatureLogger

import RIBs

protocol OnboardingFortuneGuideDependency: Dependency {
    var logger: Logger { get }
}

final class OnboardingFortuneGuideComponent: Component<OnboardingFortuneGuideDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol OnboardingFortuneGuideBuildable: Buildable {
    func build(withListener listener: OnboardingFortuneGuideListener) -> OnboardingFortuneGuideRouting
}

final class OnboardingFortuneGuideBuilder: Builder<OnboardingFortuneGuideDependency>, OnboardingFortuneGuideBuildable {

    override init(dependency: OnboardingFortuneGuideDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OnboardingFortuneGuideListener) -> OnboardingFortuneGuideRouting {
        let component = OnboardingFortuneGuideComponent(dependency: dependency)
        let viewController = OnboardingFortuneGuideViewController()
        let interactor = OnboardingFortuneGuideInteractor(
            presenter: viewController,
            logger: dependency.logger
        )
        interactor.listener = listener
        return OnboardingFortuneGuideRouter(interactor: interactor, viewController: viewController)
    }
}
