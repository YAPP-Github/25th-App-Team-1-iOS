//
//  AuthorizationRequestViewController.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import RIBs
import RxSwift
import UIKit

enum AuthorizationRequestPresentableListenerRequest {
    case back
    case yesButtonTapped
}

protocol AuthorizationRequestPresentableListener: AnyObject {
    func request(_ request: AuthorizationRequestPresentableListenerRequest)
}

final class AuthorizationRequestViewController: UIViewController, AuthorizationRequestPresentable, AuthorizationRequestViewControllable {

    weak var listener: AuthorizationRequestPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    private let mainView = AuthorizationRequestView()
}

extension AuthorizationRequestViewController: AuthorizationRequestViewListener {
    func action(_ action: AuthorizationRequestView.Action) {
        switch action {
        case .backButtonTapped:
            listener?.request(.back)
        case .yesButtonTapped:
            listener?.request(.yesButtonTapped)
        }
    }
}
