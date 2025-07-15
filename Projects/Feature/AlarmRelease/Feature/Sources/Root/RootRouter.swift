//
//  RootRouter.swift
//  FeatureAlarmRelease
//
//  Created by ever on 7/1/25.
//

import UIKit
import RIBs
import FeatureCommonEntity
import FeatureAlarmMission
import FeatureFortune

protocol RootInteractable: Interactable,
                           AlarmReleaseIntroListener,
                           AlarmReleaseSnoozeListener,
                           AlarmMissionRootListener,
                           FortuneListener
{
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}


final class RootRouter: Router<RootInteractable>, RootRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: RootInteractable,
        presentingViewController: UIViewController,
        introBuilder: AlarmReleaseIntroBuildable,
        snoozeBuilder: AlarmReleaseSnoozeBuildable,
        missionBuilder: AlarmMissionRootBuildable,
        fortuneBuilder: FortuneBuildable
    ) {
        self.presentingViewController = presentingViewController
        self.introBuilder = introBuilder
        self.snoozeBuilder = snoozeBuilder
        self.missionBuilder = missionBuilder
        self.fortuneBuilder = fortuneBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func request(_ request: RootRouterRequest) {
        switch request {
        case .cleanUpViews:
            cleanupViews()
        case .routeToIntro:
            routeToIntro()
        case .routeToSnooze(let snoozeOption):
            routeToSnooze(snoozeOption: snoozeOption)
        case .detachSnooze:
            detachSnooze()
        case let .routeToMission(missionType):
            routeToAlarmMission(missionType: missionType)
        case .detachAlarmMission:
            detachAlarmMission({})
        case let .routeToFortune(fortune, userInfo, saveInfo):
            routeToFortune(fortune: fortune, userInfo: userInfo, fortuneInfo: saveInfo)
        case .detachFortune:
            detachFortune()
        }
    }
    
    func cleanupViews() {
        guard let navigationController else { return }
        if navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        }
        navigationController.dismiss(animated: true)
    }
    
    // MARK: - Private
    
    private let presentingViewController: UIViewController
    private var navigationController: UINavigationController?
    
    private let introBuilder: AlarmReleaseIntroBuildable
    private var introRouter: AlarmReleaseIntroRouting?
    
    private let snoozeBuilder: AlarmReleaseSnoozeBuildable
    private var snoozeRouter: AlarmReleaseSnoozeRouting?
    
    private let missionBuilder: AlarmMissionRootBuildable
    private var missionRouter: AlarmMissionRootRouting?
    
    private let fortuneBuilder: FortuneBuildable
    private var fortuneRouter: FortuneRouting?
    
    private func presentOrPush(_ router: ViewableRouting) {
        let targetVC = router.viewControllable.uiviewController
        attachChild(router)
        if let navigationController {
            navigationController.pushViewController(targetVC, animated: true)
        } else {
            let navigationController = generateNavigationControllerIfNeeded()
            navigationController.setViewControllers([targetVC], animated: false)
            presentingViewController.present(navigationController, animated: true)
            self.navigationController = navigationController
        }
    }
    
    private func generateNavigationControllerIfNeeded() -> UINavigationController {
        if let navigationController { return navigationController }
        let navigationController = UINavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
    private func routeToIntro() {
        guard introRouter == nil else { return }
        let router = introBuilder.build(withListener: interactor)
        self.introRouter = router
        presentOrPush(router)
    }
    
    private func routeToSnooze(snoozeOption: SnoozeOption) {
        guard snoozeRouter == nil else { return }
        let router = snoozeBuilder.build(withListener: interactor, snoozeOption: snoozeOption)
        self.snoozeRouter = router
        presentOrPush(router)
    }
    
    private func detachSnooze() {
        guard let router = snoozeRouter else { return }
        self.snoozeRouter = nil
        detachChild(router)
        navigationController?.popViewController(animated: true)
    }
    
    private func routeToAlarmMission(missionType: AlarmMissionType) {
        guard missionRouter == nil else { return }
        let router = missionBuilder.build(
            withListener: interactor,
            navigationController: generateNavigationControllerIfNeeded(),
            missionType: missionType
        )
        self.missionRouter = router
        attachChild(router)
    }
    
    private func detachAlarmMission(_ completion: (() -> Void)?) {
        guard let router = missionRouter else { return }
        missionRouter = nil
        detachChild(router)
        completion?()
    }
//    
    private func routeToFortune(fortune: Fortune, userInfo: UserInfo, fortuneInfo: FortuneSaveInfo) {
        guard fortuneRouter == nil else { return }
        let router = fortuneBuilder.build(withListener: interactor, fortune: fortune, userInfo: userInfo, fortuneInfo: fortuneInfo)
        self.fortuneRouter = router
        navigationController?.setNavigationBarHidden(false, animated: false)
        presentOrPush(router)
    }
    
    private func detachFortune() {
        guard let router = fortuneRouter else { return }
        fortuneRouter = nil
        detachChild(router)
    }
}
