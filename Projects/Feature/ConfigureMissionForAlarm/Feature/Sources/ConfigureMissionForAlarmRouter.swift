//
//  ConfigureMissionForAlarmRouter.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import RIBs

protocol ConfigureMissionForAlarmInteractable: Interactable {
    var router: ConfigureMissionForAlarmRouting? { get set }
    var listener: ConfigureMissionForAlarmListener? { get set }
}

protocol ConfigureMissionForAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ConfigureMissionForAlarmRouter: ViewableRouter<ConfigureMissionForAlarmInteractable, ConfigureMissionForAlarmViewControllable>, ConfigureMissionForAlarmRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ConfigureMissionForAlarmInteractable, viewController: ConfigureMissionForAlarmViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
