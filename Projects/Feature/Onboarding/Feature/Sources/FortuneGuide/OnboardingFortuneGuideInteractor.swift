//
//  OnboardingFortuneGuideInteractor.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import RIBs
import RxSwift
import FeatureCommonDependencies

protocol OnboardingFortuneGuideRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OnboardingFortuneGuidePresentable: Presentable {
    var listener: OnboardingFortuneGuidePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum OnboardingFortuneGuideListenerRequest {
    case back
    case start
}

protocol OnboardingFortuneGuideListener: AnyObject {
    func request(_ request: OnboardingFortuneGuideListenerRequest)
}

final class OnboardingFortuneGuideInteractor: PresentableInteractor<OnboardingFortuneGuidePresentable>, OnboardingFortuneGuideInteractable, OnboardingFortuneGuidePresentableListener {

    weak var router: OnboardingFortuneGuideRouting?
    weak var listener: OnboardingFortuneGuideListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: OnboardingFortuneGuidePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: OnboardingFortuneGuidePresentableListenerRequest) {
        switch request {
        case .back:
            listener?.request(.back)
        case .start:
            Preference.isOnboardingFinished = true
            listener?.request(.start)
        }
    }
}
