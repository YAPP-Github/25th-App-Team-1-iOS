//
//  AlarmReleaseSnoozeRouter.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/12/25.
//

import RIBs

protocol AlarmReleaseSnoozeInteractable: Interactable {
    var router: AlarmReleaseSnoozeRouting? { get set }
    var listener: AlarmReleaseSnoozeListener? { get set }
}

protocol AlarmReleaseSnoozeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AlarmReleaseSnoozeRouter: ViewableRouter<AlarmReleaseSnoozeInteractable, AlarmReleaseSnoozeViewControllable>, AlarmReleaseSnoozeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AlarmReleaseSnoozeInteractable, viewController: AlarmReleaseSnoozeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
