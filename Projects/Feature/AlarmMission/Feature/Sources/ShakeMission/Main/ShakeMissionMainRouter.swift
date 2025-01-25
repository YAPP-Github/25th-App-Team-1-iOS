//
//  ShakeMissionMainRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import RIBs

import FeatureDesignSystem

protocol ShakeMissionMainInteractable: Interactable, ShakeMissionWorkingListener {
    var router: ShakeMissionMainRouting? { get set }
    var listener: ShakeMissionMainListener? { get set }
}

protocol ShakeMissionMainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ShakeMissionMainRouter: ViewableRouter<ShakeMissionMainInteractable, ShakeMissionMainViewControllable>, ShakeMissionMainRouting, DSTwoButtonAlertPresentable, DSTwoButtonAlertViewControllerListener {
    
    // Navigation
    private let navigationController: UINavigationController
    
    
    // Builder & Router
    private let shakeMissionWorkingBuilder: ShakeMissionWorkingBuilder
    private var shakeMissionWorkingRouter: ShakeMissionWorkingRouting?
    
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        navigationController: UINavigationController,
        interactor: ShakeMissionMainInteractable,
        viewController: ShakeMissionMainViewControllable,
        shakeMissionWorkingBuilder: ShakeMissionWorkingBuilder
    ) {
        self.navigationController = navigationController
        self.shakeMissionWorkingBuilder = shakeMissionWorkingBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
        
        // navigationController
        navigationController.isNavigationBarHidden = true
    }
}


// MARK: ShakeMissionMainRouting
extension ShakeMissionMainRouter {
    
    func request(_ request: ShakeMissionMainRoutingRequest) {
        switch request {
        case .presentWorkingPage:
            presentShakeMissionWorkingPage()
        case .dissmissWorkingPage:
            dismissShakeMissionWorkingPage()
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


// MARK: Routing RIB
private extension ShakeMissionMainRouter {
    
    func presentShakeMissionWorkingPage() {
        let router = shakeMissionWorkingBuilder.build(withListener: interactor)
        self.shakeMissionWorkingRouter = router
        attachChild(router)
        let viewController = router.viewControllable.uiviewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func dismissShakeMissionWorkingPage() {
        guard let shakeMissionWorkingRouter else { return }
        detachChild(shakeMissionWorkingRouter)
        navigationController.popViewController(animated: true)
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
