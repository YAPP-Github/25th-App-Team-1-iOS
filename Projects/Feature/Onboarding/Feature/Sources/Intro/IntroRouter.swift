//
//  IntroRouter.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

protocol IntroInteractable: Interactable {
    var router: IntroRouting? { get set }
    var listener: IntroListener? { get set }
}

protocol IntroViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class IntroRouter: ViewableRouter<IntroInteractable, IntroViewControllable>, IntroRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: IntroInteractable, viewController: IntroViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
