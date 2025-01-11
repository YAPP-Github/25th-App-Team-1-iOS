//
//  AuthorizationDeniedRouter.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import RIBs

protocol AuthorizationDeniedInteractable: Interactable {
    var router: AuthorizationDeniedRouting? { get set }
    var listener: AuthorizationDeniedListener? { get set }
}

protocol AuthorizationDeniedViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AuthorizationDeniedRouter: ViewableRouter<AuthorizationDeniedInteractable, AuthorizationDeniedViewControllable>, AuthorizationDeniedRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AuthorizationDeniedInteractable, viewController: AuthorizationDeniedViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
