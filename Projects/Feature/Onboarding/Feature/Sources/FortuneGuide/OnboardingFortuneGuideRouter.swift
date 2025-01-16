//
//  OnboardingFortuneGuideRouter.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import RIBs

protocol OnboardingFortuneGuideInteractable: Interactable {
    var router: OnboardingFortuneGuideRouting? { get set }
    var listener: OnboardingFortuneGuideListener? { get set }
}

protocol OnboardingFortuneGuideViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class OnboardingFortuneGuideRouter: ViewableRouter<OnboardingFortuneGuideInteractable, OnboardingFortuneGuideViewControllable>, OnboardingFortuneGuideRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: OnboardingFortuneGuideInteractable, viewController: OnboardingFortuneGuideViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
