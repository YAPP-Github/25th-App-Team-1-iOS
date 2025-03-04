//
//  MissionRootRouter.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import FeatureUIDependencies

import RIBs

protocol MissionRootInteractable: Interactable, ShakeMissionMainListener, TapMissionMainListener {
    var router: MissionRootRouting? { get set }
    var listener: MissionRootListener? { get set }
}

final class MissionRootRouter: Router<MissionRootInteractable>, MissionRootRouting, DSButtonAlertPresentable {
    
    private var navigationController: UINavigationController?
    
    // Builder
    private let shakeMissionBuilder: ShakeMissionMainBuilder
    private let tapMissionBuilder: TapMissionMainBuilder
    
    // Router
    private var shakeMissionRouter: ShakeMissionMainRouting?
    private var tapMissionRouter: TapMissionMainRouting?
    
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MissionRootInteractable,
        viewController: UIViewController,
        shakeMissionBuilder: ShakeMissionMainBuilder,
        tapMissionBuilder: TapMissionMainBuilder
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
    
    private func dismissOrPopViewController(animated: Bool = true) {
        if let navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: animated)
            }
            else {
                navigationController.setViewControllers([], animated: animated)
                navigationController.dismiss(animated: animated)
                self.navigationController = nil
            }
        } else {
            // 네비게이션 컨트롤러가 없는 경우 or 현재 화면이 네비게이션의 RootVC인 경우
            viewController.dismiss(animated: animated)
        }
    }
}


// MARK: MissionRootRouting
extension MissionRootRouter {
    func request(_ request: MissionRootRoutingRequest) {
        switch request {
        case .dismissMission(let mission):
            switch mission {
            case .shake:
                dismissShakeMission()
            case .tap:
                dismissTapMission()
            }
        case .presentShakeMission(let isFirstAlarm):
            presentShakeMission(isFirstAlarm: isFirstAlarm)
        case .presentTapMission:
            presentTapMission()
        case .presentAlert(let config):
            presentAlert(
                presentingController: viewController,
                listener: nil,
                config: config
            )
        }
    }
}


// MARK: Routing RIB
private extension MissionRootRouter {
    // Shake mission
    func presentShakeMission(isFirstAlarm: Bool) {
        let router = shakeMissionBuilder.build(withListener: interactor, isFirstAlarm: isFirstAlarm)
        self.shakeMissionRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    func dismissShakeMission() {
        guard let shakeMissionRouter else { return }
        dismissOrPopViewController()
        detachChild(shakeMissionRouter)
        self.shakeMissionRouter = nil
        print("흔들기 미션 RIB dettach")
    }
    
    
    // Tap mission
    func presentTapMission() {
        let router = tapMissionBuilder.build(withListener: interactor)
        self.tapMissionRouter = router
        attachChild(router)
        presentOrPushViewController(with: router)
    }
    func dismissTapMission() {
        guard let tapMissionRouter else { return }
        dismissOrPopViewController()
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {[weak self] in
            self?.detachChild(tapMissionRouter)
        }
        self.tapMissionRouter = nil
    }
}
