//
//  OnboardingMissionGuideBuilder.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import RIBs

protocol OnboardingMissionGuideDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class OnboardingMissionGuideComponent: Component<OnboardingMissionGuideDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol OnboardingMissionGuideBuildable: Buildable {
    func build(withListener listener: OnboardingMissionGuideListener) -> OnboardingMissionGuideRouting
}

final class OnboardingMissionGuideBuilder: Builder<OnboardingMissionGuideDependency>, OnboardingMissionGuideBuildable {

    override init(dependency: OnboardingMissionGuideDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: OnboardingMissionGuideListener) -> OnboardingMissionGuideRouting {
        let component = OnboardingMissionGuideComponent(dependency: dependency)
        let viewController = OnboardingMissionGuideViewController()
        let interactor = OnboardingMissionGuideInteractor(presenter: viewController)
        interactor.listener = listener
        return OnboardingMissionGuideRouter(interactor: interactor, viewController: viewController)
    }
}
