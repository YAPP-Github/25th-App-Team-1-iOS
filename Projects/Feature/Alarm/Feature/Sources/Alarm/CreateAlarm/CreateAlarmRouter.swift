//
//  CreateAlarmRouter.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs

protocol CreateAlarmInteractable: Interactable {
    var router: CreateAlarmRouting? { get set }
    var listener: CreateAlarmListener? { get set }
}

protocol CreateAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CreateAlarmRouter: ViewableRouter<CreateAlarmInteractable, CreateAlarmViewControllable>, CreateAlarmRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CreateAlarmInteractable, viewController: CreateAlarmViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
