//
//  InputBirthDayBuilder.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs

protocol InputBirthDayDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class InputBirthDayComponent: Component<InputBirthDayDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol InputBirthDayBuildable: Buildable {
    func build(withListener listener: InputBirthDayListener) -> InputBirthDayRouting
}

final class InputBirthDayBuilder: Builder<InputBirthDayDependency>, InputBirthDayBuildable {

    override init(dependency: InputBirthDayDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputBirthDayListener) -> InputBirthDayRouting {
        let component = InputBirthDayComponent(dependency: dependency)
        let viewController = InputBirthDayViewController()
        let interactor = InputBirthDayInteractor(presenter: viewController)
        interactor.listener = listener
        return InputBirthDayRouter(interactor: interactor, viewController: viewController)
    }
}
