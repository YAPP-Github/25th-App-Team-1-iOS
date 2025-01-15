//
//  InputSummaryRouter.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import RIBs

protocol InputSummaryInteractable: Interactable {
    var router: InputSummaryRouting? { get set }
    var listener: InputSummaryListener? { get set }
}

protocol InputSummaryViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class InputSummaryRouter: ViewableRouter<InputSummaryInteractable, InputSummaryViewControllable>, InputSummaryRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: InputSummaryInteractable, viewController: InputSummaryViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
