//
//  IntroBuilder.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

protocol IntroDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class IntroComponent: Component<IntroDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol IntroBuildable: Buildable {
    func build(withListener listener: IntroListener) -> IntroRouting
}

final class IntroBuilder: Builder<IntroDependency>, IntroBuildable {

    override init(dependency: IntroDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: IntroListener) -> IntroRouting {
        let component = IntroComponent(dependency: dependency)
        let viewController = IntroViewController()
        let interactor = IntroInteractor(presenter: viewController)
        interactor.listener = listener
        return IntroRouter(interactor: interactor, viewController: viewController)
    }
}
