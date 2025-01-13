//
//  AuthorizationRequestInteractor.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import RIBs
import RxSwift
import UIKit

protocol AuthorizationRequestRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AuthorizationRequestPresentable: Presentable {
    var listener: AuthorizationRequestPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum AuthorizationRequestListenerRequest {
    case agree
    case disagree
}

protocol AuthorizationRequestListener: AnyObject {
    func request(_ request: AuthorizationRequestListenerRequest)
}

final class AuthorizationRequestInteractor: PresentableInteractor<AuthorizationRequestPresentable>, AuthorizationRequestInteractable, AuthorizationRequestPresentableListener {

    weak var router: AuthorizationRequestRouting?
    weak var listener: AuthorizationRequestListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: AuthorizationRequestPresentable,
        service: AuthorizationRequestServiceable
    ) {
        self.service = service
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
    
    private let service: AuthorizationRequestServiceable
    
    func request(_ request: AuthorizationRequestPresentableListenerRequest) {
        switch request {
        case .yesButtonTapped:
            requestPermission()
        }
    }
    
    private func requestPermission() {
        service.requestPermission { [weak listener] granted in
            DispatchQueue.main.async {
                if granted {
                    listener?.request(.agree)
                } else {
                    listener?.request(.disagree)
                }
            }
        }
    }
}
