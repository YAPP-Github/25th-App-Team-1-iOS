//
//  AlarmReleaseIntroRouter.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/10/25.
//

import RIBs

protocol AlarmReleaseIntroInteractable: Interactable {
    var router: AlarmReleaseIntroRouting? { get set }
    var listener: AlarmReleaseIntroListener? { get set }
}

protocol AlarmReleaseIntroViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AlarmReleaseIntroRouter: ViewableRouter<AlarmReleaseIntroInteractable, AlarmReleaseIntroViewControllable>, AlarmReleaseIntroRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AlarmReleaseIntroInteractable, viewController: AlarmReleaseIntroViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
