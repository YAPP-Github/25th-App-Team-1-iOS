//
//  AuthorizationDeniedBuilder.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import FeatureLogger

import RIBs

protocol AuthorizationDeniedDependency: Dependency {
    var logger: Logger { get }
}

final class AuthorizationDeniedComponent: Component<AuthorizationDeniedDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AuthorizationDeniedBuildable: Buildable {
    func build(withListener listener: AuthorizationDeniedListener) -> AuthorizationDeniedRouting
}

final class AuthorizationDeniedBuilder: Builder<AuthorizationDeniedDependency>, AuthorizationDeniedBuildable {

    override init(dependency: AuthorizationDeniedDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AuthorizationDeniedListener) -> AuthorizationDeniedRouting {
        let component = AuthorizationDeniedComponent(dependency: dependency)
        let viewController = AuthorizationDeniedViewController()
        let interactor = AuthorizationDeniedInteractor(
            presenter: viewController,
            logger: dependency.logger
        )
        interactor.listener = listener
        return AuthorizationDeniedRouter(interactor: interactor, viewController: viewController)
    }
}
