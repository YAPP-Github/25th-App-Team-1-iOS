//
//  InputGenderBuilder.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import RIBs

protocol InputGenderDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class InputGenderComponent: Component<InputGenderDependency> {
    fileprivate let model: OnboardingModel
    
    init(dependency: any InputGenderDependency, model: OnboardingModel) {
        self.model = model
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol InputGenderBuildable: Buildable {
    func build(withListener listener: InputGenderListener, model: OnboardingModel) -> InputGenderRouting
}

final class InputGenderBuilder: Builder<InputGenderDependency>, InputGenderBuildable {

    override init(dependency: InputGenderDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputGenderListener, model: OnboardingModel) -> InputGenderRouting {
        let component = InputGenderComponent(dependency: dependency, model: model)
        let viewController = InputGenderViewController()
        let interactor = InputGenderInteractor(presenter: viewController, model: component.model)
        interactor.listener = listener
        return InputGenderRouter(interactor: interactor, viewController: viewController)
    }
}
