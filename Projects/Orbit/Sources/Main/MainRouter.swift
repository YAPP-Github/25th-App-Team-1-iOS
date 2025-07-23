//
//  MainRouter.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import UIKit
import FeatureOnboarding
import FeatureMain
import FeatureAlarmRelease
import FeatureCommonEntity

import RIBs

protocol MainInteractable: Interactable,
                           FeatureOnboarding.RootListener,
                           FeatureMain.MainPageListener,
                           FeatureAlarmRelease.RootListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable,
                               FeatureOnboarding.RootViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainRouter: LaunchRouter<MainInteractable, MainViewControllable>, MainRouting {
    
    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        onboardingBuilder: FeatureOnboarding.RootBuildable,
        mainBuilder: FeatureMain.MainPageBuildable,
        alarmReleaseBuilder: FeatureAlarmRelease.RootBuildable,
        component: MainComponent
    ) {
        self.onboardingBuilder = onboardingBuilder
        self.mainBuilder = mainBuilder
        self.alarmReleaseBuilder = alarmReleaseBuilder
        self.component = component
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        print(#function)
    }
    
    func request(_ request: MainRouterRequest) {
        switch request {
        case .routeToOnboarding:
            routeToOnboarding()
        case .detachOnboarding:
            detachOnboarding()
        case let .routeToMain(completion):
            routeToMain(completion: completion)
        case .detachMain:
            detachMain()
        case let .routeToAlarmRelease(alarm, isFirstAlarm):
            routeToAlarmRelease(alarm: alarm, isFirstAlarm: isFirstAlarm)
        case .detachAlarmRelease:
            detachAlarmRelease()
        }
    }
    
    private let onboardingBuilder: FeatureOnboarding.RootBuildable
    private var onboardingRouter: FeatureOnboarding.RootRouting?
    
    private let mainBuilder: FeatureMain.MainPageBuildable
    private var mainRouter: FeatureMain.MainPageRouting?
    
    private let alarmReleaseBuilder: FeatureAlarmRelease.RootBuildable
    private var alarmReleaseRouter: FeatureAlarmRelease.RootRouting?
    private let component: MainComponent
    
    private func routeToOnboarding() {
        guard onboardingRouter == nil else { return }
        let router = onboardingBuilder.build(withListener: interactor, entryPoint: .intro)
        onboardingRouter = router
        attachChild(router)
    }
    
    private func detachOnboarding() {
        guard let router = onboardingRouter else { return }
        onboardingRouter = nil
        detachChild(router)
    }
    
    private func routeToMain(completion: ((Any) -> Void)?) {
        guard mainRouter == nil else { return }
        let router = mainBuilder.build(withListener: interactor)
        mainRouter = router
        
        // Set the main router reference in the component for AlarmRelease dependency
        component.mainRouter = router
        
        attachChild(router)
        router.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(router.viewControllable.uiviewController, animated: true)
        completion?(router)
    }
    
    private func detachMain() {
        guard let router = mainRouter else { return }
        mainRouter = nil
        component.mainRouter = nil
        detachChild(router)
    }
    
    private func routeToAlarmRelease(alarm: Alarm, isFirstAlarm: Bool) {
        guard alarmReleaseRouter == nil else { return }
        let router = alarmReleaseBuilder.build(withListener: interactor, alarm: alarm, isFirstAlarm: isFirstAlarm)
        alarmReleaseRouter = router
        attachChild(router)
        // AlarmRelease will handle its own presentation using the presentingViewController from dependency
    }
    
    private func detachAlarmRelease() {
        guard let router = alarmReleaseRouter else { return }
        alarmReleaseRouter = nil
        detachChild(router)
        // AlarmRelease will handle its own dismissal
    }
}
