//
//  InputWakeUpAlarmRouter.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import RIBs

protocol InputWakeUpAlarmInteractable: Interactable {
    var router: InputWakeUpAlarmRouting? { get set }
    var listener: InputWakeUpAlarmListener? { get set }
}

protocol InputWakeUpAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class InputWakeUpAlarmRouter: ViewableRouter<InputWakeUpAlarmInteractable, InputWakeUpAlarmViewControllable>, InputWakeUpAlarmRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: InputWakeUpAlarmInteractable, viewController: InputWakeUpAlarmViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
