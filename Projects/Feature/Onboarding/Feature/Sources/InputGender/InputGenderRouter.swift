//
//  InputGenderRouter.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import RIBs

protocol InputGenderInteractable: Interactable {
    var router: InputGenderRouting? { get set }
    var listener: InputGenderListener? { get set }
}

protocol InputGenderViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class InputGenderRouter: ViewableRouter<InputGenderInteractable, InputGenderViewControllable>, InputGenderRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: InputGenderInteractable, viewController: InputGenderViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
