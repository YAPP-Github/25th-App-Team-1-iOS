//
//  SettingMainRouter.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import RIBs

protocol SettingMainInteractable: Interactable {
    var router: SettingMainRouting? { get set }
    var listener: SettingMainListener? { get set }
}

protocol SettingMainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SettingMainRouter: ViewableRouter<SettingMainInteractable, SettingMainViewControllable>, SettingMainRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SettingMainInteractable, viewController: SettingMainViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
