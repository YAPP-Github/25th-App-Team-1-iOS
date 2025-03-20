//
//  InputNameBuilder.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import FeatureLogger

import RIBs

protocol InputNameDependency: Dependency {
    var logger: Logger { get }
}

final class InputNameComponent: Component<InputNameDependency> {
    fileprivate let model: OnboardingModel
    
    init(dependency: any InputNameDependency, model: OnboardingModel) {
        self.model = model
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol InputNameBuildable: Buildable {
    func build(withListener listener: InputNameListener, model: OnboardingModel) -> InputNameRouting
}

final class InputNameBuilder: Builder<InputNameDependency>, InputNameBuildable {

    override init(dependency: InputNameDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputNameListener, model: OnboardingModel) -> InputNameRouting {
        let component = InputNameComponent(dependency: dependency, model: model)
        let viewController = InputNameViewController()
        let interactor = InputNameInteractor(
            presenter: viewController,
            logger: dependency.logger,
            model: component.model
        )
        interactor.listener = listener
        return InputNameRouter(interactor: interactor, viewController: viewController)
    }
}
