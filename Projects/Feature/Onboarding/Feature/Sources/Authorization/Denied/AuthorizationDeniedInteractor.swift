//
//  AuthorizationDeniedInteractor.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import RIBs
import RxSwift

protocol AuthorizationDeniedRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AuthorizationDeniedPresentable: Presentable {
    var listener: AuthorizationDeniedPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum AuthorizationDeniedListenerRequest {
    case later
    case allowed
}

protocol AuthorizationDeniedListener: AnyObject {
    func request(_ request: AuthorizationDeniedListenerRequest)
}

final class AuthorizationDeniedInteractor: PresentableInteractor<AuthorizationDeniedPresentable>, AuthorizationDeniedInteractable, AuthorizationDeniedPresentableListener {

    weak var router: AuthorizationDeniedRouting?
    weak var listener: AuthorizationDeniedListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AuthorizationDeniedPresentable) {
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
    
    func request(_ request: AuthorizationDeniedPresentableListenerRequest) {
        switch request {
        case .later:
            listener?.request(.later)
        case .allowed:
            listener?.request(.allowed)
        }
    }
}
