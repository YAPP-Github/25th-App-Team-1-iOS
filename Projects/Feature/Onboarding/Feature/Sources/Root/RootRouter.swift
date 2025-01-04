//
//  RootRouter.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

protocol RootInteractable: Interactable, IntroListener, InputNameListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

public protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class RootRouter: Router<RootInteractable>, RootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        introBuilder: IntroBuildable,
        inputNameBuilder: InputNameBuilder
    ) {
        self.viewController = viewController
        self.introBuilder = introBuilder
        self.inputNameBuilder = inputNameBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    func request(_ request: RootRouterRequest) {
        switch request {
        case .cleanUpViews:
            cleanupViews()
        case .routeToIntro:
            routeToIntro()
        case .routeToInputName:
            routeToInputName()
        }
    }
    
    // MARK: - Private

    private let viewController: RootViewControllable
    
    private let introBuilder: IntroBuildable
    private var introRouter: IntroRouting?
    
    private let inputNameBuilder: InputNameBuildable
    private var inputNameRouter: InputNameRouting?
    
    private func cleanupViews() {
        
    }

    private func routeToIntro() {
        guard introRouter == nil else { return }
        let router = introBuilder.build(withListener: interactor)
        introRouter = router
        attachChild(router)
        viewController.uiviewController.present(router.viewControllable.uiviewController, animated: true)
    }
    
    private func routeToInputName() {
        guard inputNameRouter == nil else { return }
        let router = inputNameBuilder.build(withListener: interactor)
        inputNameRouter = router
        attachChild(router)
        viewController.uiviewController.present(router.viewControllable.uiviewController, animated: true)
    }
}
