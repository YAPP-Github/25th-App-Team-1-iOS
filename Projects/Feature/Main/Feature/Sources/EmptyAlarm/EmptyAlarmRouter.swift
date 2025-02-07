//
//  EmptyAlarmRouter.swift
//  FeatureMain
//
//  Created by ever on 2/7/25.
//

import RIBs

protocol EmptyAlarmInteractable: Interactable {
    var router: EmptyAlarmRouting? { get set }
    var listener: EmptyAlarmListener? { get set }
}

protocol EmptyAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class EmptyAlarmRouter: ViewableRouter<EmptyAlarmInteractable, EmptyAlarmViewControllable>, EmptyAlarmRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: EmptyAlarmInteractable, viewController: EmptyAlarmViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
