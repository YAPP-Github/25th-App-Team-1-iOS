//
//  ShakeMissionMainRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import RIBs

import FeatureDesignSystem

protocol ShakeMissionMainInteractable: Interactable {
    var router: ShakeMissionMainRouting? { get set }
    var listener: ShakeMissionMainListener? { get set }
}

protocol ShakeMissionMainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ShakeMissionMainRouter: ViewableRouter<ShakeMissionMainInteractable, ShakeMissionMainViewControllable>, ShakeMissionMainRouting, DSTwoButtonAlertPresentable, DSTwoButtonAlertViewControllerListener {

    
    // AlertTransition
    var alertTransitionDelegate: UIViewControllerTransitioningDelegate?
    
    
    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ShakeMissionMainInteractable, viewController: ShakeMissionMainViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}


// MARK: ShakeMissionMainRouting
extension ShakeMissionMainRouter {
    
    func request(_ request: ShakeMissionMainRoutingRequest) {
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
        case .exitPage:
            print("exit ShakeMissionMainPage")
        }
    }
}


// MARK: DSTwoButtonAlertViewControllerListener
extension ShakeMissionMainRouter {
    
    func action(_ action: DSTwoButtonAlertViewController.Action) {
        switch action {
        case .leftButtonClicked:
            print("left")
        case .rightButtonClicked:
            print("right")
        }
    }
}
