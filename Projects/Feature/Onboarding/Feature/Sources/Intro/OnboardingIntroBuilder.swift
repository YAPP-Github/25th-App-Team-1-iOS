//
//  OnboardingIntroBuilder.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

protocol OnboardingIntroDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class OnboardingIntroComponent: Component<OnboardingIntroDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol OnboardingIntroBuildable: Buildable {
    func build(withListener listener: OnboardingIntroListener) -> OnboardingIntroRouting
}

final class OnboardingIntroBuilder: Builder<OnboardingIntroDependency>, OnboardingIntroBuildable {

    override init(dependency: OnboardingIntroDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OnboardingIntroListener) -> OnboardingIntroRouting {
        let component = OnboardingIntroComponent(dependency: dependency)
        let viewController = OnboardingIntroViewController()
        let interactor = OnboardingIntroInteractor(presenter: viewController)
        interactor.listener = listener
        return OnboardingIntroRouter(interactor: interactor, viewController: viewController)
    }
}
