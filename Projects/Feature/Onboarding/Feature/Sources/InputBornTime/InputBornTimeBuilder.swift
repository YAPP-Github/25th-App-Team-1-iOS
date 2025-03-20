//
//  InputBornTimeBuilder.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import FeatureLogger

import RIBs

protocol InputBornTimeDependency: Dependency {
    var logger: Logger { get }
}

final class InputBornTimeComponent: Component<InputBornTimeDependency> {
    fileprivate let model: OnboardingModel
    
    init(dependency: any InputBornTimeDependency, model: OnboardingModel) {
        self.model = model
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol InputBornTimeBuildable: Buildable {
    func build(withListener listener: InputBornTimeListener, model: OnboardingModel) -> InputBornTimeRouting
}

final class InputBornTimeBuilder: Builder<InputBornTimeDependency>, InputBornTimeBuildable {

    override init(dependency: InputBornTimeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputBornTimeListener, model: OnboardingModel) -> InputBornTimeRouting {
        let component = InputBornTimeComponent(dependency: dependency, model: model)
        let viewController = InputBornTimeViewController()
        let interactor = InputBornTimeInteractor(
            presenter: viewController,
            logger: dependency.logger,
            model: component.model
        )
        interactor.listener = listener
        return InputBornTimeRouter(interactor: interactor, viewController: viewController)
    }
}
