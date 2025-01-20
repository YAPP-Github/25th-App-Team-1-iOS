//
//  ShakeMissionWorkingRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs

protocol ShakeMissionWorkingInteractable: Interactable {
    var router: ShakeMissionWorkingRouting? { get set }
    var listener: ShakeMissionWorkingListener? { get set }
}

protocol ShakeMissionWorkingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ShakeMissionWorkingRouter: ViewableRouter<ShakeMissionWorkingInteractable, ShakeMissionWorkingViewControllable>, ShakeMissionWorkingRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ShakeMissionWorkingInteractable, viewController: ShakeMissionWorkingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
