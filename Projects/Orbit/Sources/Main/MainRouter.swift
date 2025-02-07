//
//  MainRouter.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import FeatureOnboarding
import FeatureAlarm

protocol MainInteractable: Interactable,
                           FeatureOnboarding.RootListener,
                           FeatureAlarm.RootListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable,
                               FeatureOnboarding.RootViewControllable,
                               FeatureAlarm.RootViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainRouter: LaunchRouter<MainInteractable, MainViewControllable>, MainRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        onboardingBuilder: FeatureOnboarding.RootBuildable,
        alarmBuilder: FeatureAlarm.RootBuildable
    ) {
        self.onboardingBuilder = onboardingBuilder
        self.alarmBuilder = alarmBuilder
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
        case .routeToAlarm:
            routeToAlarm()
        case .detachAlarm:
            detachAlarm()
        }
    }
    
    private let onboardingBuilder: FeatureOnboarding.RootBuildable
    private var onboardingRouter: FeatureOnboarding.RootRouting?
    
    private let alarmBuilder: FeatureAlarm.RootBuildable
    private var alarmRouter: FeatureAlarm.RootRouting?
    
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
    
    private func routeToAlarm() {
        guard alarmRouter == nil else { return }
        let router = alarmBuilder.build(withListener: interactor)
        alarmRouter = router
        attachChild(router)
    }
    
    private func detachAlarm() {
        guard let router = alarmRouter else { return }
        alarmRouter = nil
        detachChild(router)
    }
}
