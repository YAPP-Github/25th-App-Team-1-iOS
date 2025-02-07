//
//  InputWakeUpAlarmBuilder.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import RIBs

protocol InputWakeUpAlarmDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class InputWakeUpAlarmComponent: Component<InputWakeUpAlarmDependency> {
    fileprivate let model: OnboardingModel
    
    init(dependency: any InputWakeUpAlarmDependency, model: OnboardingModel) {
        self.model = model
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol InputWakeUpAlarmBuildable: Buildable {
    func build(withListener listener: InputWakeUpAlarmListener, model: OnboardingModel) -> InputWakeUpAlarmRouting
}

final class InputWakeUpAlarmBuilder: Builder<InputWakeUpAlarmDependency>, InputWakeUpAlarmBuildable {

    override init(dependency: InputWakeUpAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputWakeUpAlarmListener, model: OnboardingModel) -> InputWakeUpAlarmRouting {
        let component = InputWakeUpAlarmComponent(dependency: dependency, model: model)
        let viewController = InputWakeUpAlarmViewController()
        let interactor = InputWakeUpAlarmInteractor(presenter: viewController, model: component.model)
        interactor.listener = listener
        return InputWakeUpAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
