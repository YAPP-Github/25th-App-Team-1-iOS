//
//  CreateAlarmSnoozeOptionRouter.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs

protocol CreateAlarmSnoozeOptionInteractable: Interactable {
    var router: CreateAlarmSnoozeOptionRouting? { get set }
    var listener: CreateAlarmSnoozeOptionListener? { get set }
}

protocol CreateAlarmSnoozeOptionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CreateAlarmSnoozeOptionRouter: ViewableRouter<CreateAlarmSnoozeOptionInteractable, CreateAlarmSnoozeOptionViewControllable>, CreateAlarmSnoozeOptionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CreateAlarmSnoozeOptionInteractable, viewController: CreateAlarmSnoozeOptionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
