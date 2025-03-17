//
//  AuthorizationRequestInteractor.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import UIKit

import FeatureLogger

import RIBs
import RxSwift

protocol AuthorizationRequestRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AuthorizationRequestPresentable: Presentable {
    var listener: AuthorizationRequestPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

enum AuthorizationRequestListenerRequest {
    case back
    case agree
    case disagree
}

protocol AuthorizationRequestListener: AnyObject {
    func request(_ request: AuthorizationRequestListenerRequest)
}

final class AuthorizationRequestInteractor: PresentableInteractor<AuthorizationRequestPresentable>, AuthorizationRequestInteractable, AuthorizationRequestPresentableListener {
    // Dependency
    private let logger: Logger

    weak var router: AuthorizationRequestRouting?
    weak var listener: AuthorizationRequestListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: AuthorizationRequestPresentable,
        logger: Logger,
        service: AuthorizationRequestServiceable
    ) {
        self.service = service
        self.logger = logger
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
        case .viewDidLoad:
            let log = PageViewLogBuilder(event: .permission).build()
            logger.send(log)
        case .back:
            listener?.request(.back)
        case .requestAuthorization:
            requestAuthorization()
        }
    }
    
    private func requestAuthorization() {
        service.requestPermission { [weak listener] granted in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let log = PageActionBuilder(event: .permissionAccept)
                    .setProperty(
                        key: "permission",
                        value: granted ? "허용" : "거부"
                    )
                    .build()
                logger.send(log)
                
                if granted {
                    listener?.request(.agree)
                } else {
                    listener?.request(.disagree)
                }
            }
        }
    }
}
