//
//  ConfigureUserInfoRouter.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import RIBs

protocol ConfigureUserInfoInteractable: Interactable {
    var router: ConfigureUserInfoRouting? { get set }
    var listener: ConfigureUserInfoListener? { get set }
}

protocol ConfigureUserInfoViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ConfigureUserInfoRouter: ViewableRouter<ConfigureUserInfoInteractable, ConfigureUserInfoViewControllable>, ConfigureUserInfoRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ConfigureUserInfoInteractable, viewController: ConfigureUserInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
