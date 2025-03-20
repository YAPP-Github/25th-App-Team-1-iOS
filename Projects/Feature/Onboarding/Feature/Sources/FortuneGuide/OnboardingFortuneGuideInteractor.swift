//
//  OnboardingFortuneGuideInteractor.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import FeatureLogger
import FeatureCommonDependencies

import RIBs
import RxSwift

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
    // Dependency
    private let logger: Logger

    weak var router: OnboardingFortuneGuideRouting?
    weak var listener: OnboardingFortuneGuideListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: OnboardingFortuneGuidePresentable, logger: Logger) {
        self.logger = logger
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: OnboardingFortuneGuidePresentableListenerRequest) {
        switch request {
        case .back:
            listener?.request(.back)
        case .start:
            Preference.isOnboardingFinished = true
            
            let log = PageActionBuilder(event: .complete).build()
            logger.send(log)
            
            listener?.request(.start)
        }
    }
}
