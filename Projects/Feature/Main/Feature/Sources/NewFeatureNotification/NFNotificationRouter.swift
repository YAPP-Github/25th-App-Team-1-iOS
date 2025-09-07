//
//  NFNotificationRouter.swift
//  FeatureMain
//
//  Created by choijunios on 9/7/25.
//

import RIBs

protocol NFNotificationInteractable: Interactable {
    var router: NFNotificationRouting? { get set }
    var listener: NFNotificationListener? { get set }
}

protocol NFNotificationViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class NFNotificationRouter: ViewableRouter<NFNotificationInteractable, NFNotificationViewControllable>, NFNotificationRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: NFNotificationInteractable, viewController: NFNotificationViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
