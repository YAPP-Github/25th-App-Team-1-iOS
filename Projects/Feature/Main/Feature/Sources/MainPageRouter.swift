//
//  MainPageRouter.swift
//  FeatureMain
//
//  Created by choijunios on 1/27/25.
//

import RIBs
import UIKit
import FeatureCommonDependencies
import FeatureDesignSystem
import FeatureAlarm
import FeatureFortune
import FeatureSetting

protocol MainPageInteractable: Interactable,
                               FeatureAlarm.RootListener,
                               FeatureFortune.FortuneListener,
                               SettingMainListener {
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
        fortuneBuilder: FeatureFortune.FortuneBuildable,
        settingBuilder: SettingMainBuildable,
        nFNotificationBuilder: NFNotificationBuilder
    ) {
        self.alarmBuilder = alarmBuilder
        self.fortuneBuilder = fortuneBuilder
        self.settingBuilder = settingBuilder
        self.nFNotificationBuilder = nFNotificationBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: MainPageRouterRequest) {
        switch request {
        case let .routeToCreateEditAlarm(mode):
            routeToCreateAlarm(mode: mode)
        case .detachCreateEditAlarm:
            detachCreateEditAlarm()
        case let .routeToFortune(fortune, userInfo, fortuneInfo):
            routeToFortune(fortune: fortune, userInfo: userInfo, fortuneInfo: fortuneInfo)
        case .detachFortune:
            detachFortune()
        case .presentAlertType1(let config):
            presentAlert(
                presentingController: viewController.uiviewController,
                listener: nil,
                config: config
            )
        case .presentAlertType2(let config):
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
        case .presentSettingPage:
            routeToSetting()
        case .dismissSettingPage:
            detachSetting()
            
        case .attachNFNotification(let listener):
            attachNFNotification(listener: listener)
            
        case .dettachNFNotification:
            dettachNFNotification()
            
        case .presentNFNotificationPage:
            guard let router = nFNotificationRouter else { return }
            let vc = router.viewControllable.uiviewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            viewController.uiviewController.present(vc, animated: true)
            
        case .dismissNFNotificationPage:
            guard nFNotificationRouter != nil else { return }
            viewController.uiviewController.dismiss(animated: true)
            dettachNFNotification()
        }
    }
    
    private let alarmBuilder: FeatureAlarm.RootBuildable
    private var alarmRouter: FeatureAlarm.RootRouting?
    
    private let fortuneBuilder: FeatureFortune.FortuneBuildable
    private var fortuneRouter: FeatureFortune.FortuneRouting?
    
    
    private let settingBuilder: FeatureSetting.SettingMainBuildable
    private var settingRouter: FeatureSetting.SettingMainRouting?
    
    private let nFNotificationBuilder: NFNotificationBuilder
    private var nFNotificationRouter: NFNotificationRouting?
    
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
    
    private func routeToFortune(fortune: Fortune, userInfo: UserInfo, fortuneInfo: FortuneSaveInfo) {
        guard fortuneRouter == nil else { return }
        let router = fortuneBuilder.build(withListener: interactor, fortune: fortune, userInfo: userInfo, fortuneInfo: fortuneInfo)
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
    
    
    private func routeToSetting() {
        guard settingRouter == nil else { return }
        let router = settingBuilder.build(withListener: interactor)
        self.settingRouter = router
        attachChild(router)
        let navigationController = UINavigationController(rootViewController: router.viewControllable.uiviewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isNavigationBarHidden = true
        viewController.uiviewController.present(navigationController, animated: true)
    }
    
    private func detachSetting() {
        guard let router = settingRouter else { return }
        self.settingRouter = nil
        detachChild(router)
        viewController.uiviewController.dismiss(animated: true)
    }
    
    private func attachNFNotification(listener: NFNotificationListener) {
        let router = nFNotificationBuilder.build(withListener: listener)
        self.nFNotificationRouter = router
        attachChild(router)
    }
    
    private func dettachNFNotification() {
        guard let router = nFNotificationRouter else { return }
        self.nFNotificationRouter = nil
        detachChild(router)
    }
}


// MARK: DSTwoButtonAlertPresentable
extension MainPageRouter {
    
    
}
