//
//  InputNameRouter.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

protocol InputNameInteractable: Interactable {
    var router: InputNameRouting? { get set }
    var listener: InputNameListener? { get set }
}

protocol InputNameViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class InputNameRouter: ViewableRouter<InputNameInteractable, InputNameViewControllable>, InputNameRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: InputNameInteractable, viewController: InputNameViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
