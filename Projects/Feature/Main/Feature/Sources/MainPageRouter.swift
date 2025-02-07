//
//  MainPageRouter.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import FeatureDesignSystem

protocol MainPageInteractable: Interactable {
    var router: MainPageRouting? { get set }
    var listener: MainPageListener? { get set }
}

protocol MainPageViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainPageRouter: ViewableRouter<MainPageInteractable, MainPageViewControllable>, MainPageRouting, DSButtonAlertPresentable {
    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MainPageInteractable, viewController: MainPageViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: MainPageRouterRequest) {
        switch request {
        case .presentAlert(let config, let listener):
            presentAlert(
                presentingController: viewController.uiviewController,
                listener: listener,
                config: config
            )
        case .dismissAlert(let completion):
            dismissAlert(
                presentingController: viewController.uiviewController,
                completion: completion
            )
        }
    }
}
