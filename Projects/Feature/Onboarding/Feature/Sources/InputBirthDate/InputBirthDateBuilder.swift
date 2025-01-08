//
//  InputBirthDateBuilder.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs

protocol InputBirthDateDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class InputBirthDateComponent: Component<InputBirthDateDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol InputBirthDateBuildable: Buildable {
    func build(withListener listener: InputBirthDateListener) -> InputBirthDateRouting
}

final class InputBirthDateBuilder: Builder<InputBirthDateDependency>, InputBirthDateBuildable {

    override init(dependency: InputBirthDateDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputBirthDateListener) -> InputBirthDateRouting {
        let component = InputBirthDateComponent(dependency: dependency)
        let viewController = InputBirthDateViewController()
        let interactor = InputBirthDateInteractor(presenter: viewController)
        interactor.listener = listener
        return InputBirthDateRouter(interactor: interactor, viewController: viewController)
    }
}
