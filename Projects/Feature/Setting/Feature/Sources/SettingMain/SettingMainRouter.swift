//
//  SettingMainRouter.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import RIBs

protocol SettingMainInteractable: Interactable {
    var router: SettingMainRouting? { get set }
    var listener: SettingMainListener? { get set }
}

protocol SettingMainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SettingMainRouter: ViewableRouter<SettingMainInteractable, SettingMainViewControllable>, SettingMainRouting {
    // Dependency
    private let navigationController: UINavigationController
    
    
    // Builders
    private let configureUserInfoBuilder: ConfigureUserInfoBuilder
    
    
    // Router
    private var configureUserInfoRouter: ConfigureUserInfoRouting?
    
    
    init(
        interactor: SettingMainInteractable,
        viewController: SettingMainViewControllable,
        configureUserInfoBuilder: ConfigureUserInfoBuilder,
        navigationController: UINavigationController
    ) {
        self.configureUserInfoBuilder = configureUserInfoBuilder
        self.navigationController = navigationController
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
        navigationController.isNavigationBarHidden = true
    }
}


// MARK: SettingMainRouting
extension SettingMainRouter {
    func request(_ request: SettingMainRoutingRequest) {
        switch request {
        case .presentEditUserInfoPage(let userInfo, let listener):
            if configureUserInfoRouter != nil { return }
            let router = configureUserInfoBuilder.build(userInfo: userInfo, withListener: listener)
            self.configureUserInfoRouter = router
            attachChild(router)
            navigationController.pushViewController(
                router.viewControllable.uiviewController,
                animated: true
            )
        case .dismissEditUserInfoPage:
            guard let configureUserInfoRouter else { return }
            detachChild(configureUserInfoRouter)
            self.configureUserInfoRouter = nil
            navigationController.popViewController(animated: true)
        case .presentWebPage(let url):
            UIApplication.shared.open(url)
        }
    }
}
