//
//  InputSummaryBuilder.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import RIBs

protocol InputSummaryDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class InputSummaryComponent: Component<InputSummaryDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol InputSummaryBuildable: Buildable {
    func build(withListener listener: InputSummaryListener, onBoardingModel: OnboardingModel) -> InputSummaryRouting
}

final class InputSummaryBuilder: Builder<InputSummaryDependency>, InputSummaryBuildable {

    override init(dependency: InputSummaryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputSummaryListener, onBoardingModel: OnboardingModel) -> InputSummaryRouting {
        let component = InputSummaryComponent(dependency: dependency)
        let viewController = InputSummaryViewController()
        let interactor = InputSummaryInteractor(
            presenter: viewController,
            onBoardingModel: onBoardingModel
        )
        interactor.listener = listener
        return InputSummaryRouter(interactor: interactor, viewController: viewController)
    }
}
