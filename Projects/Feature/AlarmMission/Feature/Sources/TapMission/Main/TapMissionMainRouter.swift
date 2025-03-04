//
//  TapMissionMainRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import FeatureUIDependencies

import RIBs

protocol TapMissionMainInteractable: Interactable, TapMissionWorkingListener {
    var router: TapMissionMainRouting? { get set }
    var listener: TapMissionMainListener? { get set }
}

protocol TapMissionMainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class TapMissionMainRouter: ViewableRouter<TapMissionMainInteractable, TapMissionMainViewControllable>, TapMissionMainRouting, DSTwoButtonAlertPresentable {

    // Navigation
    private var navigationController: UINavigationController?
    
    
    // Builder & Router
    private let tapMissionWorkingBuilder: TapMissionWorkingBuilder
    private var tapMissionWorkingRouter: TapMissionWorkingRouting?
    
    init(
        interactor: TapMissionMainInteractable,
        viewController: TapMissionMainViewControllable,
        tapMissionWorkingBuilder: TapMissionWorkingBuilder
    ) {
        self.tapMissionWorkingBuilder = tapMissionWorkingBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    private func presentOrPushViewController(with router: ViewableRouting, animated: Bool = true) {
        if let navigationController {
            navigationController.pushViewController(router.viewControllable.uiviewController, animated: animated)
        } else {
            let navigationController = UINavigationController(rootViewController: router.viewControllable.uiviewController)
            navigationController.isNavigationBarHidden = true
            navigationController.modalPresentationStyle = .fullScreen
            viewController.uiviewController.present(navigationController, animated: animated)
            self.navigationController = navigationController
        }
    }
    
    private func dismissOrPopViewController(animated: Bool = true) {
        if let navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: animated)
            }
            else {
                navigationController.setViewControllers([], animated: true)
                navigationController.dismiss(animated: true)
                self.navigationController = nil
            }
        } else {
            // 네비게이션 컨트롤러가 없는 경우 or 현재 화면이 네비게이션의 RootVC인 경우
            viewController.uiviewController.dismiss(animated: animated)
    
        }
    }
}


// MARK: TapMissionMainRouting
extension TapMissionMainRouter {
    func request(_ request: ShakeMissionMainRoutingRequest) {
        switch request {
        case .presentWorkingPage:
            presentTapMissionWorkingPage()
        case .dissmissWorkingPage:
            dismissTapMissionWorkingPage()
        case .presentAlert(let config):
            presentAlert(
                presentingController: viewController.uiviewController,
                listener: nil,
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


// MARK: Routing RIB
private extension TapMissionMainRouter {
    func presentTapMissionWorkingPage() {
        let router = tapMissionWorkingBuilder.build(withListener: interactor)
        self.tapMissionWorkingRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    
    func dismissTapMissionWorkingPage() {
        guard let tapMissionWorkingRouter else { return }
        detachChild(tapMissionWorkingRouter)
        self.tapMissionWorkingRouter = nil
        dismissOrPopViewController()
    }
}
