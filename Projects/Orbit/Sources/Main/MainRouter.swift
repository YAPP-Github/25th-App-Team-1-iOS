//
//  MainRouter.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import FeatureOnboarding

protocol MainInteractable: Interactable, FeatureOnboarding.RootListener {
    var router: MainRouting? { get set }
    var listener: MainListener? { get set }
}

protocol MainViewControllable: ViewControllable, FeatureOnboarding.RootViewControllable  {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MainRouter: LaunchRouter<MainInteractable, MainViewControllable>, MainRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: MainInteractable,
        viewController: MainViewControllable,
        onboardingBuilder: FeatureOnboarding.RootBuildable
    ) {
        self.onboardingBuilder = onboardingBuilder
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
        case .routeToAlarm:
            routeToAlarm()
        }
    }
    
    private let onboardingBuilder: FeatureOnboarding.RootBuildable
    private var onboardingRouter: FeatureOnboarding.RootRouting?
    
    private func routeToOnboarding() {
        guard onboardingRouter == nil else { return }
        
        let router = onboardingBuilder.build(withListener: interactor, entryPoint: .intro)
        onboardingRouter = router
        attachChild(router)
    }
    
    private func routeToAlarm() {
        
    }
}
