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

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol InputWakeUpAlarmBuildable: Buildable {
    func build(withListener listener: InputWakeUpAlarmListener) -> InputWakeUpAlarmRouting
}

final class InputWakeUpAlarmBuilder: Builder<InputWakeUpAlarmDependency>, InputWakeUpAlarmBuildable {

    override init(dependency: InputWakeUpAlarmDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputWakeUpAlarmListener) -> InputWakeUpAlarmRouting {
        let component = InputWakeUpAlarmComponent(dependency: dependency)
        let viewController = InputWakeUpAlarmViewController()
        let interactor = InputWakeUpAlarmInteractor(presenter: viewController)
        interactor.listener = listener
        return InputWakeUpAlarmRouter(interactor: interactor, viewController: viewController)
    }
}
