//
//  CreateEditAlarmSnoozeOptionRouter.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs

protocol CreateEditAlarmSnoozeOptionInteractable: Interactable {
    var router: CreateEditAlarmSnoozeOptionRouting? { get set }
    var listener: CreateEditAlarmSnoozeOptionListener? { get set }
}

protocol CreateEditAlarmSnoozeOptionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CreateEditAlarmSnoozeOptionRouter: ViewableRouter<CreateEditAlarmSnoozeOptionInteractable, CreateEditAlarmSnoozeOptionViewControllable>, CreateEditAlarmSnoozeOptionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CreateEditAlarmSnoozeOptionInteractable, viewController: CreateEditAlarmSnoozeOptionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
