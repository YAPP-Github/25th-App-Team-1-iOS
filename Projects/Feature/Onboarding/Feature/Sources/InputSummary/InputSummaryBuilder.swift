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
    fileprivate let model: OnboardingModel
    
    init(dependency: any InputSummaryDependency, model: OnboardingModel) {
        self.model = model
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol InputSummaryBuildable: Buildable {
    func build(withListener listener: InputSummaryListener, model: OnboardingModel) -> InputSummaryRouting
}

final class InputSummaryBuilder: Builder<InputSummaryDependency>, InputSummaryBuildable {

    override init(dependency: InputSummaryDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputSummaryListener, model: OnboardingModel) -> InputSummaryRouting {
        let component = InputSummaryComponent(dependency: dependency, model: model)
        let viewController = InputSummaryViewController()
        let interactor = InputSummaryInteractor(
            presenter: viewController,
            model: component.model
        )
        interactor.listener = listener
        return InputSummaryRouter(interactor: interactor, viewController: viewController)
    }
}
