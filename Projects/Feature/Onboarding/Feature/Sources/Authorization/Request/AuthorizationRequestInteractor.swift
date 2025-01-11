//
//  AuthorizationRequestInteractor.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import RIBs
import RxSwift

protocol AuthorizationRequestRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AuthorizationRequestPresentable: Presentable {
    var listener: AuthorizationRequestPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AuthorizationRequestListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AuthorizationRequestInteractor: PresentableInteractor<AuthorizationRequestPresentable>, AuthorizationRequestInteractable, AuthorizationRequestPresentableListener {

    weak var router: AuthorizationRequestRouting?
    weak var listener: AuthorizationRequestListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AuthorizationRequestPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
