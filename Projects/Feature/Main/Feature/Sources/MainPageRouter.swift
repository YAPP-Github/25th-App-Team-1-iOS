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
import FeatureFortune

protocol MainPageInteractable: Interactable,
                               FeatureAlarm.RootListener,
                               FeatureAlarmMission.ShakeMissionMainListener,
                               FeatureFortune.FortuneListener {
    var router: MainPageRouting? { get set }
    var listener: MainPageListener? { get set }
}

protocol MainPageViewControllable: ViewControllable,
                                   FeatureAlarm.RootViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainPageRouter: ViewableRouter<MainPageInteractable, MainPageViewControllable>, MainPageRouting, DSButtonAlertPresentable, DSTwoButtonAlertPresentable {
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MainPageInteractable,
        viewController: MainPageViewControllable,
        alarmBuilder: FeatureAlarm.RootBuildable,
        alarmMissionBuilder: FeatureAlarmMission.ShakeMissionMainBuildable,
        fortuneBuilder: FeatureFortune.FortuneBuildable
    ) {
        self.alarmBuilder = alarmBuilder
        self.alarmMissionBuilder = alarmMissionBuilder
        self.fortuneBuilder = fortuneBuilder
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
        case let .detachAlarmMission(completion):
            detachAlarmMission(completion)
        case .routeToFortune:
            routeToFortune()
        case .detachFortune:
            detachFortune()
        case .presentAlertType1(let config, let listener):
            presentAlert(
                presentingController: viewController.uiviewController,
                listener: listener,
                config: config
            )
        case .presentAlertType2(let config, let listener):
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
    
    private let fortuneBuilder: FeatureFortune.FortuneBuildable
    private var fortuneRouter: FeatureFortune.FortuneRouting?
    
    private var navigationController: UINavigationController?
    
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
        router.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(router.viewControllable.uiviewController, animated: true)
    }
    
    private func detachAlarmMission(_ completion: (() -> Void)?) {
        guard let router = alarmMissionRouter else { return }
        alarmMissionRouter = nil
        viewController.uiviewController.dismiss(animated: true) { [weak self] in
            self?.detachChild(router)
            completion?()
        }
    }
    
    private func routeToFortune() {
        guard fortuneRouter == nil else { return }
        let router = fortuneBuilder.build(withListener: interactor)
        self.fortuneRouter = router
        attachChild(router)
        let navigationController = UINavigationController(rootViewController: router.viewControllable.uiviewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(navigationController, animated: true)
        self.navigationController = navigationController
    }
    
    private func detachFortune() {
        guard let router = fortuneRouter else { return }
        fortuneRouter = nil
        detachChild(router)
        
        if let navigationController {
            navigationController.setViewControllers([], animated: true)
            navigationController.dismiss(animated: true) { [weak self] in
                self?.detachChild(router)
            }
        }
        navigationController = nil
    }
}


// MARK: DSTwoButtonAlertPresentable
extension MainPageRouter {
    
    
}
