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
    
    func presentTwoButtonAlert(config: DSTwoButtonAlert.Config, listener: any DSTwoButtonAlertViewControllerListener) {
        
        presentAlert(
            presentingController: viewController.uiviewController,
            listener: listener,
            config: config
        )
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
