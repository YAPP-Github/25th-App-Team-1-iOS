//
//  OnboardingMissionGuideBuilder.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import FeatureLogger

import RIBs

protocol OnboardingMissionGuideDependency: Dependency {
    var logger: Logger { get }
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
        let interactor = OnboardingMissionGuideInteractor(
            presenter: viewController,
            logger: dependency.logger
        )
        interactor.listener = listener
        return OnboardingMissionGuideRouter(interactor: interactor, viewController: viewController)
    }
}
