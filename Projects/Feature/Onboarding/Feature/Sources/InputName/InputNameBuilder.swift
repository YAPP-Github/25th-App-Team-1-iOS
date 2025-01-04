//
//  InputNameBuilder.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

protocol InputNameDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class InputNameComponent: Component<InputNameDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol InputNameBuildable: Buildable {
    func build(withListener listener: InputNameListener) -> InputNameRouting
}

final class InputNameBuilder: Builder<InputNameDependency>, InputNameBuildable {

    override init(dependency: InputNameDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputNameListener) -> InputNameRouting {
        let component = InputNameComponent(dependency: dependency)
        let viewController = InputNameViewController()
        let interactor = InputNameInteractor(presenter: viewController)
        interactor.listener = listener
        return InputNameRouter(interactor: interactor, viewController: viewController)
    }
}
