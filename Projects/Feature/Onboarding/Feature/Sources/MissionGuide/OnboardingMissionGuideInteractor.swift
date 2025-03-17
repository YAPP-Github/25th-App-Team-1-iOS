//
//  OnboardingMissionGuideInteractor.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import FeatureLogger

import RIBs
import RxSwift

protocol OnboardingMissionGuideRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol OnboardingMissionGuidePresentable: Presentable {
    var listener: OnboardingMissionGuidePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum OnboardingMissionGuideListenerRequest {
    case back
    case next
}

protocol OnboardingMissionGuideListener: AnyObject {
    func request(_ request: OnboardingMissionGuideListenerRequest)
}

final class OnboardingMissionGuideInteractor: PresentableInteractor<OnboardingMissionGuidePresentable>, OnboardingMissionGuideInteractable, OnboardingMissionGuidePresentableListener {
    // Dependency
    private let logger: Logger

    weak var router: OnboardingMissionGuideRouting?
    weak var listener: OnboardingMissionGuideListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: OnboardingMissionGuidePresentable, logger: Logger) {
        self.logger = logger
        super.init(presenter: presenter)
        presenter.listener = self
    }

    func request(_ request: OnboardingMissionGuidePresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            let log = PageViewLogBuilder(event: .welcome1).build()
            logger.send(log)
        case .back:
            listener?.request(.back)
        case .next:
            listener?.request(.next)
        }
    }
}
