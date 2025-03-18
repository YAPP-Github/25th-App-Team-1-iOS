//
//  MainRouter.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import FeatureOnboarding
import FeatureMain

import RIBs

protocol MainInteractable: Interactable,
                           FeatureOnboarding.RootListener,
                           FeatureMain.MainPageListener {
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
        mainBuilder: FeatureMain.MainPageBuildable
    ) {
        self.onboardingBuilder = onboardingBuilder
        self.mainBuilder = mainBuilder
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
        }
    }
    
    private let onboardingBuilder: FeatureOnboarding.RootBuildable
    private var onboardingRouter: FeatureOnboarding.RootRouting?
    
    private let mainBuilder: FeatureMain.MainPageBuildable
    private var mainRouter: FeatureMain.MainPageRouting?
    
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
    
    private func routeToMain(completion: ((MainPageActionableItem) -> Void)?) {
        guard mainRouter == nil else { return }
        let (router, actionableItem) = mainBuilder.build(withListener: interactor)
        mainRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.modalPresentationStyle = .fullScreen
        viewController.uiviewController.present(router.viewControllable.uiviewController, animated: true)
        completion?(actionableItem)
    }
    
    private func detachMain() {
        guard let router = mainRouter else { return }
        mainRouter = nil
        detachChild(router)
    }
}
