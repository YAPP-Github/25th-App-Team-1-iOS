//
//  OnboardingIntroInteractor.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import FeatureLogger

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
    
    // Dependency
    private let logger: Logger

    weak var router: OnboardingIntroRouting?
    weak var listener: OnboardingIntroListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(logger: Logger, presenter: OnboardingIntroPresentable) {
        self.logger = logger
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func request(_ request: OnboardingIntroPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            let log = PageViewLogBuilder(event: .intro).build()
            logger.send(log)
        case .next:
            let log = PageActionBuilder(event: .introNext)
                .setProperty(key: "step", value: "서비스 소개")
                .build()
            logger.send(log)
            listener?.request(.next)
        }
    }
}
