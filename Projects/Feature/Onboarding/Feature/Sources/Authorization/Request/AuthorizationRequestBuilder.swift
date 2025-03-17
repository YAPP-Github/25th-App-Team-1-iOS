//
//  AuthorizationRequestBuilder.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import FeatureLogger

import RIBs

protocol AuthorizationRequestDependency: Dependency {
    var logger: Logger { get }
}

final class AuthorizationRequestComponent: Component<AuthorizationRequestDependency> {
    let service: AuthorizationRequestServiceable
    
    init(dependency: AuthorizationRequestDependency,
         service: AuthorizationRequestServiceable = AuthorizationRequestService()) {
        self.service = service
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol AuthorizationRequestBuildable: Buildable {
    func build(withListener listener: AuthorizationRequestListener) -> AuthorizationRequestRouting
}

final class AuthorizationRequestBuilder: Builder<AuthorizationRequestDependency>, AuthorizationRequestBuildable {

    override init(dependency: AuthorizationRequestDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AuthorizationRequestListener) -> AuthorizationRequestRouting {
        let component = AuthorizationRequestComponent(dependency: dependency)
        let viewController = AuthorizationRequestViewController()
        let interactor = AuthorizationRequestInteractor(
            presenter: viewController,
            logger: dependency.logger,
            service: component.service
        )
        interactor.listener = listener
        return AuthorizationRequestRouter(interactor: interactor, viewController: viewController)
    }
}
