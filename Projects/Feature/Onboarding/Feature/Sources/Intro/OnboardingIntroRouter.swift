//
//  OnboardingIntroRouter.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs

protocol OnboardingIntroInteractable: Interactable {
    var router: OnboardingIntroRouting? { get set }
    var listener: OnboardingIntroListener? { get set }
}

protocol OnboardingIntroViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class OnboardingIntroRouter: ViewableRouter<OnboardingIntroInteractable, OnboardingIntroViewControllable>, OnboardingIntroRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: OnboardingIntroInteractable, viewController: OnboardingIntroViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
