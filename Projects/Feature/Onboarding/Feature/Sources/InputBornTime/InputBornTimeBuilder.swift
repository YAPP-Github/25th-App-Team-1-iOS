//
//  InputBornTimeBuilder.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

protocol InputBornTimeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
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
        let interactor = InputBornTimeInteractor(presenter: viewController, model: component.model)
        interactor.listener = listener
        return InputBornTimeRouter(interactor: interactor, viewController: viewController)
    }
}
