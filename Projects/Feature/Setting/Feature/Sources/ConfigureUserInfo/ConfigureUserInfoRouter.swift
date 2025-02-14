//
//  ConfigureUserInfoRouter.swift
//  FeatureSetting
//
//  Created by choijunios on 2/13/25.
//

import FeatureUIDependencies

import RIBs

protocol ConfigureUserInfoInteractable: Interactable, ConfigureBirthDateViewControllerListener {
    var router: ConfigureUserInfoRouting? { get set }
    var listener: ConfigureUserInfoListener? { get set }
}

protocol ConfigureUserInfoViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ConfigureUserInfoRouter: ViewableRouter<ConfigureUserInfoInteractable, ConfigureUserInfoViewControllable>, ConfigureUserInfoRouting, DSTwoButtonAlertPresentable {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ConfigureUserInfoInteractable, viewController: ConfigureUserInfoViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}


// MARK: ConfigureUserInfoRouting
extension ConfigureUserInfoRouter {
    func request(_ request: ConfigureUserInfoRoutingRequest) {
        switch request {
        case .presentAlert(let config):
            presentAlert(
                presentingController: self.viewControllable.uiviewController,
                listener: nil,
                config: config
            )
        case .dismissAlert:
            dismissAlert(presentingController: self.viewControllable.uiviewController)
        case .presentEditBirthDatePage(let date):
            let vc = ConfigureBirthDateViewController(initialDate: date)
            vc.listener = self.interactor
            vc.modalPresentationStyle = .fullScreen
            self.viewControllable.uiviewController.present(vc, animated: true)
        case .dismissEditBirthDatePage:
            let presented = self.viewControllable.uiviewController.presentedViewController
            if let vc = presented as? ConfigureBirthDateViewController {
                vc.dismiss(animated: true)
            }
        }
    }
}
