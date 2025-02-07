//
//  MainInteractor.swift
//  Orbit
//
//  Created by 손병근 on 1/4/25.
//

import RIBs
import RxSwift
import FeatureOnboarding
import FeatureCommonDependencies

enum MainRouterRequest {
    case routeToOnboarding
    case detachOnboarding
    case routeToMain
    case detachMain
}

protocol MainRouting: ViewableRouting {
    func request(_ request: MainRouterRequest)
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol MainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener {

    weak var router: MainRouting?
    weak var listener: MainListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MainPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        if Preference.isOnboardingFinished {
            router?.request(.routeToMain)
        } else {
            router?.request(.routeToOnboarding)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

// MARK: OnboardRootListenerRequest
extension MainInteractor {
    func request(_ request: RootListenerRequest) {
        switch request {
        case .start:
            router?.request(.detachOnboarding)
            router?.request(.routeToMain)
        }
    }
}
