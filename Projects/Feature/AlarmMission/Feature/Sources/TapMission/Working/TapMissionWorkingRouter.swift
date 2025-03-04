//
//  TapMissionWorkingRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import RIBs

import FeatureUIDependencies

protocol TapMissionWorkingInteractable: Interactable {
    var router: TapMissionWorkingRouting? { get set }
    var listener: TapMissionWorkingListener? { get set }
}

protocol TapMissionWorkingViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TapMissionWorkingRouter: ViewableRouter<TapMissionWorkingInteractable, TapMissionWorkingViewControllable>, TapMissionWorkingRouting, DSTwoButtonAlertPresentable {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: TapMissionWorkingInteractable, viewController: TapMissionWorkingViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}


// MARK: TapMissionWorkingRouting
extension TapMissionWorkingRouter {
    func request(_ request: TapMissionWorkingRoutingRequest) {
        switch request {
        case .presentAlert(let config):
            let presentingViewController = viewController.uiviewController
            presentAlert(
                presentingController: presentingViewController,
                listener: nil,
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
