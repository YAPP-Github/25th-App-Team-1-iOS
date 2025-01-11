//
//  AuthorizationRequestRouter.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import RIBs

protocol AuthorizationRequestInteractable: Interactable {
    var router: AuthorizationRequestRouting? { get set }
    var listener: AuthorizationRequestListener? { get set }
}

protocol AuthorizationRequestViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AuthorizationRequestRouter: ViewableRouter<AuthorizationRequestInteractable, AuthorizationRequestViewControllable>, AuthorizationRequestRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AuthorizationRequestInteractable, viewController: AuthorizationRequestViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
