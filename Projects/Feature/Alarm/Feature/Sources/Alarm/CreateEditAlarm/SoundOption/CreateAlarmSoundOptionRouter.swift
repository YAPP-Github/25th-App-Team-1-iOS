//
//  CreateEditAlarmSoundOptionRouter.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs

protocol CreateEditAlarmSoundOptionInteractable: Interactable {
    var router: CreateEditAlarmSoundOptionRouting? { get set }
    var listener: CreateEditAlarmSoundOptionListener? { get set }
}

protocol CreateEditAlarmSoundOptionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CreateEditAlarmSoundOptionRouter: ViewableRouter<CreateEditAlarmSoundOptionInteractable, CreateEditAlarmSoundOptionViewControllable>, CreateEditAlarmSoundOptionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CreateEditAlarmSoundOptionInteractable, viewController: CreateEditAlarmSoundOptionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
