//
//  InputBirthDayRouter.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs

protocol InputBirthDayInteractable: Interactable {
    var router: InputBirthDayRouting? { get set }
    var listener: InputBirthDayListener? { get set }
}

protocol InputBirthDayViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class InputBirthDayRouter: ViewableRouter<InputBirthDayInteractable, InputBirthDayViewControllable>, InputBirthDayRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: InputBirthDayInteractable, viewController: InputBirthDayViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
