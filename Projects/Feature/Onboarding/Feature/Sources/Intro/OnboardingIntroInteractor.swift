//
//  OnboardingIntroInteractor.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift

protocol OnboardingIntroRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OnboardingIntroPresentable: Presentable {
    var listener: OnboardingIntroPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum OnboardingIntroListenerRequest {
    case next
}

protocol OnboardingIntroListener: AnyObject {
    func request(_ request: OnboardingIntroListenerRequest)
}

final class OnboardingIntroInteractor: PresentableInteractor<OnboardingIntroPresentable>, OnboardingIntroInteractable, OnboardingIntroPresentableListener {

    weak var router: OnboardingIntroRouting?
    weak var listener: OnboardingIntroListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: OnboardingIntroPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: OnboardingIntroPresentableListenerRequest) {
        switch request {
        case .next:
            listener?.request(.next)
        }
    }
}
