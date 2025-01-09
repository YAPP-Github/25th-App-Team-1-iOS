//
//  InputBirthDateRouter.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import RIBs

protocol InputBirthDateInteractable: Interactable {
    var router: InputBirthDateRouting? { get set }
    var listener: InputBirthDateListener? { get set }
}

protocol InputBirthDateViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class InputBirthDateRouter: ViewableRouter<InputBirthDateInteractable, InputBirthDateViewControllable>, InputBirthDateRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: InputBirthDateInteractable, viewController: InputBirthDateViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
