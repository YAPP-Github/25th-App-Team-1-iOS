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

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol InputGenderBuildable: Buildable {
    func build(withListener listener: InputGenderListener) -> InputGenderRouting
}

final class InputGenderBuilder: Builder<InputGenderDependency>, InputGenderBuildable {

    override init(dependency: InputGenderDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputGenderListener) -> InputGenderRouting {
        let component = InputGenderComponent(dependency: dependency)
        let viewController = InputGenderViewController()
        let interactor = InputGenderInteractor(presenter: viewController)
        interactor.listener = listener
        return InputGenderRouter(interactor: interactor, viewController: viewController)
    }
}
