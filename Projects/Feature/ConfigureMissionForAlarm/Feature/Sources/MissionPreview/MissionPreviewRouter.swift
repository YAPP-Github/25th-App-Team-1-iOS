//
//  MissionPreviewRouter.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/23/25.
//

import RIBs

protocol MissionPreviewInteractable: Interactable {
    var router: MissionPreviewRouting? { get set }
    var listener: MissionPreviewListener? { get set }
}

protocol MissionPreviewViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MissionPreviewRouter: ViewableRouter<MissionPreviewInteractable, MissionPreviewViewControllable>, MissionPreviewRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MissionPreviewInteractable, viewController: MissionPreviewViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
