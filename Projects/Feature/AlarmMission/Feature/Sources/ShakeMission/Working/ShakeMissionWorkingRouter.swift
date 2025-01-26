//
//  ShakeMissionWorkingRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs

import FeatureDesignSystem

protocol ShakeMissionWorkingInteractable: Interactable {
    var router: ShakeMissionWorkingRouting? { get set }
    var listener: ShakeMissionWorkingListener? { get set }
}

protocol ShakeMissionWorkingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ShakeMissionWorkingRouter: ViewableRouter<ShakeMissionWorkingInteractable, ShakeMissionWorkingViewControllable>, ShakeMissionWorkingRouting, DSTwoButtonAlertPresentable {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ShakeMissionWorkingInteractable, viewController: ShakeMissionWorkingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}


// MARK: ShakeMissionWorkingRouting
extension ShakeMissionWorkingRouter {
    func request(_ request: ShakeMissionWorkingRoutingRequest) {
        switch request {
        case .presentAlert(let config, let listener):
            let presentingViewController = viewController.uiviewController
            presentAlert(
                presentingController: presentingViewController,
                listener: listener,
                config: config
            )
        case .dismissAlert(let completion):
            let presentingViewController = viewController.uiviewController
            dismissAlert(
                presentingController: presentingViewController,
                completion: completion
            )
        }
    }
}
