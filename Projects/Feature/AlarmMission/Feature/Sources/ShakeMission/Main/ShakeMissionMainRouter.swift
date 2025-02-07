//
//  ShakeMissionMainRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import RIBs

import FeatureUIDependencies

protocol ShakeMissionMainInteractable: Interactable, ShakeMissionWorkingListener {
    var router: ShakeMissionMainRouting? { get set }
    var listener: ShakeMissionMainListener? { get set }
}

protocol ShakeMissionMainViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ShakeMissionMainRouter: ViewableRouter<ShakeMissionMainInteractable, ShakeMissionMainViewControllable>, ShakeMissionMainRouting, DSTwoButtonAlertPresentable {
    
    // Navigation
    private var navigationController: UINavigationController?
    
    // Builder & Router
    private let shakeMissionWorkingBuilder: ShakeMissionWorkingBuilder
    private var shakeMissionWorkingRouter: ShakeMissionWorkingRouting?
    
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: ShakeMissionMainInteractable,
        viewController: ShakeMissionMainViewControllable,
        shakeMissionWorkingBuilder: ShakeMissionWorkingBuilder
    ) {
        self.shakeMissionWorkingBuilder = shakeMissionWorkingBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
        
        // navigationController
        
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
        if let navigationController,
           navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: animated)
        } else {
            // 네비게이션 컨트롤러가 없는 경우 or 현재 화면이 네비게이션의 RootVC인 경우
            viewController.uiviewController.dismiss(animated: animated)
            navigationController = nil
        }
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
        presentOrPushViewController(with: router)
    }
    
    func dismissShakeMissionWorkingPage() {
        guard let shakeMissionWorkingRouter else { return }
        detachChild(shakeMissionWorkingRouter)
        dismissOrPopViewController()
    }
}
