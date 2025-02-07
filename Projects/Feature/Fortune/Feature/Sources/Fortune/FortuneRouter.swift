//
//  FortuneRouter.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import RIBs

protocol FortuneInteractable: Interactable {
    var router: FortuneRouting? { get set }
    var listener: FortuneListener? { get set }
}

protocol FortuneViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class FortuneRouter: ViewableRouter<FortuneInteractable, FortuneViewControllable>, FortuneRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: FortuneInteractable, viewController: FortuneViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
