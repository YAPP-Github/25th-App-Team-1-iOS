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
    case viewDidLoad
    case back
    case requestAuthorization
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
        listener?.request(.viewDidLoad)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak listener] in
            listener?.request(.requestAuthorization)
        }
    }
    
    private let mainView = AuthorizationRequestView()
}

extension AuthorizationRequestViewController: AuthorizationRequestViewListener {
    func action(_ action: AuthorizationRequestView.Action) {
        switch action {
        case .backButtonTapped:
            listener?.request(.back)
        }
    }
}
