//
//  MissionRootRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import FeatureUIDependencies

import RIBs

protocol AlarmMissionRootInteractable: Interactable, ShakeMissionWorkingListener, TapMissionWorkingListener {
    var router: AlarmMissionRootRouting? { get set }
    var listener: AlarmMissionRootListener? { get set }
    var isPreviewMode: Bool { get }
}

final class AlarmMissionRootRouter: Router<AlarmMissionRootInteractable>, AlarmMissionRootRouting, DSButtonAlertPresentable {
    
    private var navigationController: UINavigationController?
    
    // Builder
    private let shakeMissionBuilder: ShakeMissionWorkingBuilder
    private let tapMissionBuilder: TapMissionWorkingBuilder
    
    // Router
    private var shakeMissionRouter: ShakeMissionWorkingRouting?
    private var tapMissionRouter: TapMissionWorkingRouting?
    
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: AlarmMissionRootInteractable,
        viewController: UIViewController,
        shakeMissionBuilder: ShakeMissionWorkingBuilder,
        tapMissionBuilder: TapMissionWorkingBuilder
    ) {
        self.viewController = viewController
        self.shakeMissionBuilder = shakeMissionBuilder
        self.tapMissionBuilder = tapMissionBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }

    // MARK: - Private

    private let viewController: UIViewController
    
    
    private func presentOrPushViewController(with router: ViewableRouting, animated: Bool = true) {
        if let navigationController {
            navigationController.pushViewController(router.viewControllable.uiviewController, animated: animated)
        } else {
            let navigationController = UINavigationController(rootViewController: router.viewControllable.uiviewController)
            navigationController.isNavigationBarHidden = true
            navigationController.modalPresentationStyle = .fullScreen
            viewController.present(navigationController, animated: animated)
            self.navigationController = navigationController
        }
    }
    
    private func dismissOrPopViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: animated)
            }
            else {
                navigationController.setViewControllers([], animated: true)
                navigationController.dismiss(animated: true, completion: completion)
                self.navigationController = nil
            }
        } else {
            // 네비게이션 컨트롤러가 없는 경우 or 현재 화면이 네비게이션의 RootVC인 경우
            viewController.dismiss(animated: animated, completion: completion)
        }
    }
}


// MARK: MissionRootRouting
extension AlarmMissionRootRouter {
    func request(_ request: AlarmMissionRootRoutingRequest) {
        switch request {
        case .dismissMission(let mission, let completion):
            switch mission {
            case .shake:
                dismissShakeMission(completion: completion)
            case .tap:
                dismissTapMission(completion: completion)
            }
        case .presentShakeMission:
            presentShakeMission()
        case .presentTapMission:
            presentTapMission()
        case .presentAlert(let config):
            guard let navigationController else { return }
            presentAlert(
                presentingController: navigationController,
                listener: nil,
                config: config
            )
        case .dismissAlert(let completion):
            guard let navigationController else { return }
            dismissAlert(presentingController: navigationController, completion: completion)
        }
    }
}


// MARK: Routing RIB
private extension AlarmMissionRootRouter {
    // Shake mission
    func presentShakeMission() {
        let router = shakeMissionBuilder.build(withListener: interactor, isPreviewMode: interactor.isPreviewMode)
        self.shakeMissionRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    func dismissShakeMission(completion: (() -> Void)? = nil) {
        guard let shakeMissionRouter else { return }
        dismissOrPopViewController(completion: completion)
        detachChild(shakeMissionRouter)
        self.shakeMissionRouter = nil
        print("흔들기 미션 RIB dettach")
    }
    
    
    // Tap mission
    func presentTapMission() {
        let router = tapMissionBuilder.build(withListener: interactor, isPreviewMode: interactor.isPreviewMode)
        self.tapMissionRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    func dismissTapMission(completion: (() -> Void)? = nil) {
        guard let tapMissionRouter else { return }
        dismissOrPopViewController(completion: completion)
        detachChild(tapMissionRouter)
        self.tapMissionRouter = nil
    }
}
