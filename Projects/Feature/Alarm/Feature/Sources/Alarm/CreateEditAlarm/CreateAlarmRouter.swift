//
//  CreateEditAlarmRouter.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs

protocol CreateEditAlarmInteractable: Interactable {
    var router: CreateEditAlarmRouting? { get set }
    var listener: CreateEditAlarmListener? { get set }
}

protocol CreateEditAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CreateEditAlarmRouter: ViewableRouter<CreateEditAlarmInteractable, CreateEditAlarmViewControllable>, CreateEditAlarmRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CreateEditAlarmInteractable, viewController: CreateEditAlarmViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
