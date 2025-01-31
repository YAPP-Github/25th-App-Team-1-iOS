//
//  MainPageRouter.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs

protocol MainPageInteractable: Interactable {
    var router: MainPageRouting? { get set }
    var listener: MainPageListener? { get set }
}

protocol MainPageViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainPageRouter: ViewableRouter<MainPageInteractable, MainPageViewControllable>, MainPageRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MainPageInteractable, viewController: MainPageViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
