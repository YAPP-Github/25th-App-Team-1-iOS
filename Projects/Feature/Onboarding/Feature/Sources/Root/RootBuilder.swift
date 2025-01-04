//
//  RootBuilder.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

public protocol RootDependency: Dependency {
    // TODO: Make sure to convert the variable into lower-camelcase.
    var rootViewController: RootViewControllable { get }
    // TODO: Declare the set of dependencies required by this RIB, but won't be
    // created by this RIB.
}

final class RootComponent: Component<RootDependency> {

    // TODO: Make sure to convert the variable into lower-camelcase.
    fileprivate var rootViewController: RootViewControllable {
        return dependency.rootViewController
    }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

public protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener) -> RootRouting
}

public final class RootBuilder: Builder<RootDependency>, RootBuildable {

    public override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    public func build(withListener listener: RootListener) -> RootRouting {
        let component = RootComponent(dependency: dependency)
        let interactor = RootInteractor()
        interactor.listener = listener
        return RootRouter(interactor: interactor, viewController: component.rootViewController)
    }
}
