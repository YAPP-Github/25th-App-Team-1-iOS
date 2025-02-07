//
//  MainPageRouter.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import UIKit
import FeatureDesignSystem
import FeatureAlarm
import FeatureAlarmMission

protocol MainPageInteractable: Interactable,
                               FeatureAlarm.RootListener,
                               FeatureAlarmMission.ShakeMissionMainListener {
    var router: MainPageRouting? { get set }
    var listener: MainPageListener? { get set }
}

protocol MainPageViewControllable: ViewControllable,
                                   FeatureAlarm.RootViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainPageRouter: ViewableRouter<MainPageInteractable, MainPageViewControllable>, MainPageRouting, DSButtonAlertPresentable {
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MainPageInteractable,
        viewController: MainPageViewControllable,
        alarmBuilder: FeatureAlarm.RootBuildable,
        alarmMissionBuilder: FeatureAlarmMission.ShakeMissionMainBuildable
    ) {
        self.alarmBuilder = alarmBuilder
        self.alarmMissionBuilder = alarmMissionBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: MainPageRouterRequest) {
        switch request {
        case let .routeToCreateEditAlarm(mode):
            routeToCreateAlarm(mode: mode)
        case .detachCreateEditAlarm:
            detachCreateEditAlarm()
        case .routeToAlarmMission:
            routeToAlarmMission()
        case .detachAlarmMission:
            detachAlarmMission()
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
    
    private let alarmBuilder: FeatureAlarm.RootBuildable
    private var alarmRouter: FeatureAlarm.RootRouting?
    
    private let alarmMissionBuilder: FeatureAlarmMission.ShakeMissionMainBuildable
    private var alarmMissionRouter: FeatureAlarmMission.ShakeMissionMainRouting?
    
    var navigationController: UINavigationController?
    
    private func routeToCreateAlarm(mode: AlarmCreateEditMode) {
        guard alarmRouter == nil else { return }
        let router = alarmBuilder.build(withListener: interactor, mode: mode)
        self.alarmRouter = router
        attachChild(router)
    }
    
    private func detachCreateEditAlarm() {
        guard let router = alarmRouter else { return }
        alarmRouter = nil
        detachChild(router)
    }
    
    private func routeToAlarmMission() {
        guard alarmMissionRouter == nil else { return }
        let router = alarmMissionBuilder.build(withListener: interactor)
        self.alarmMissionRouter = router
        attachChild(router)
        let navigatinoController = UINavigationController(rootViewController: router.viewControllable.uiviewController)
        navigatinoController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(navigatinoController, animated: true)
        self.navigationController = navigatinoController
    }
    
    private func detachAlarmMission() {
        guard let router = alarmMissionRouter else { return }
        alarmMissionRouter = nil
        detachChild(router)
        if let navigationController {
            navigationController.setViewControllers([], animated: true)
            self.navigationController = nil
        }
        viewController.uiviewController.dismiss(animated: true)
    }
}
