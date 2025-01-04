//
//  InputBornTimeRouter.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

protocol InputBornTimeInteractable: Interactable {
    var router: InputBornTimeRouting? { get set }
    var listener: InputBornTimeListener? { get set }
}

protocol InputBornTimeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class InputBornTimeRouter: ViewableRouter<InputBornTimeInteractable, InputBornTimeViewControllable>, InputBornTimeRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: InputBornTimeInteractable, viewController: InputBornTimeViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
