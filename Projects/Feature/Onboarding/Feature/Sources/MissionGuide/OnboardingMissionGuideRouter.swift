//
//  OnboardingMissionGuideRouter.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import RIBs

protocol OnboardingMissionGuideInteractable: Interactable {
    var router: OnboardingMissionGuideRouting? { get set }
    var listener: OnboardingMissionGuideListener? { get set }
}

protocol OnboardingMissionGuideViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class OnboardingMissionGuideRouter: ViewableRouter<OnboardingMissionGuideInteractable, OnboardingMissionGuideViewControllable>, OnboardingMissionGuideRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: OnboardingMissionGuideInteractable, viewController: OnboardingMissionGuideViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
