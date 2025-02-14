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
    
    

    // Builders
    private let configureUserInfoBuilder: ConfigureUserInfoBuilder
    
    init(
        interactor: SettingMainInteractable,
        viewController: SettingMainViewControllable,
        configureUserInfoBuilder: ConfigureUserInfoBuilder
    ) {
        self.configureUserInfoBuilder = configureUserInfoBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}


// MARK: SettingMainRouting
extension SettingMainRouter {
    func request(_ request: SettingMainRoutingRequest) {
        switch request {
        case .presentEditUserInfo:
            break
        }
    }
}
