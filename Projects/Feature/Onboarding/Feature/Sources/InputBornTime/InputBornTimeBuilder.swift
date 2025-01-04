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

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol InputBornTimeBuildable: Buildable {
    func build(withListener listener: InputBornTimeListener) -> InputBornTimeRouting
}

final class InputBornTimeBuilder: Builder<InputBornTimeDependency>, InputBornTimeBuildable {

    override init(dependency: InputBornTimeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: InputBornTimeListener) -> InputBornTimeRouting {
        let component = InputBornTimeComponent(dependency: dependency)
        let viewController = InputBornTimeViewController()
        let interactor = InputBornTimeInteractor(presenter: viewController)
        interactor.listener = listener
        return InputBornTimeRouter(interactor: interactor, viewController: viewController)
    }
}
