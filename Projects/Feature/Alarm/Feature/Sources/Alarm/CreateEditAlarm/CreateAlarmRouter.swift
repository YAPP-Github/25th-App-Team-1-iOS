//
//  CreateEditAlarmRouter.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs
import FeatureDesignSystem

protocol CreateEditAlarmInteractable: Interactable {
    var router: CreateEditAlarmRouting? { get set }
    var listener: CreateEditAlarmListener? { get set }
}

protocol CreateEditAlarmViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class CreateEditAlarmRouter: ViewableRouter<CreateEditAlarmInteractable, CreateEditAlarmViewControllable>, CreateEditAlarmRouting, DSTwoButtonAlertPresentable {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: CreateEditAlarmInteractable, viewController: CreateEditAlarmViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: CreateEditAlarmRouterRequest) {
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
