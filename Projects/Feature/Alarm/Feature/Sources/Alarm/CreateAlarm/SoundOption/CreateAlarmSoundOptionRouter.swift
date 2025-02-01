//
//  CreateAlarmSoundOptionRouter.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs

protocol CreateAlarmSoundOptionInteractable: Interactable {
    var router: CreateAlarmSoundOptionRouting? { get set }
    var listener: CreateAlarmSoundOptionListener? { get set }
}

protocol CreateAlarmSoundOptionViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CreateAlarmSoundOptionRouter: ViewableRouter<CreateAlarmSoundOptionInteractable, CreateAlarmSoundOptionViewControllable>, CreateAlarmSoundOptionRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CreateAlarmSoundOptionInteractable, viewController: CreateAlarmSoundOptionViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
