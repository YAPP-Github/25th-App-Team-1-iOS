//
//  InputBirthDateBuilder.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import FeatureLogger

import RIBs

protocol InputBirthDateDependency: Dependency {
    var logger: Logger { get }
}

final class InputBirthDateComponent: Component<InputBirthDateDependency> {
    fileprivate let model: OnboardingModel
    
    init(dependency: any InputBirthDateDependency, model: OnboardingModel) {
        self.model = model
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol InputBirthDateBuildable: Buildable {
    func build(withListener listener: InputBirthDateListener, model: OnboardingModel) -> InputBirthDateRouting
}

final class InputBirthDateBuilder: Builder<InputBirthDateDependency>, InputBirthDateBuildable {

    override init(dependency: InputBirthDateDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputBirthDateListener, model: OnboardingModel) -> InputBirthDateRouting {
        let component = InputBirthDateComponent(dependency: dependency, model: model)
        let viewController = InputBirthDateViewController()
        let interactor = InputBirthDateInteractor(
            presenter: viewController,
            logger: dependency.logger,
            model: component.model
        )
        interactor.listener = listener
        return InputBirthDateRouter(interactor: interactor, viewController: viewController)
    }
}
