//
//  AuthorizationDeniedViewController.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import RIBs
import RxSwift
import UIKit

enum AuthorizationDeniedPresentableListenerRequest {
    case back
    case later
    case allowed
}

protocol AuthorizationDeniedPresentableListener: AnyObject {
    func request(_ request: AuthorizationDeniedPresentableListenerRequest)
}

final class AuthorizationDeniedViewController: UIViewController, AuthorizationDeniedPresentable, AuthorizationDeniedViewControllable {

    weak var listener: AuthorizationDeniedPresentableListener?
    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNotifications()
        navigationController?.isNavigationBarHidden = true
    }
    
    private let mainView = AuthorizationDeniedView()
    
    private func goToSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func setNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc
    private func appWillEnterForeground() {
        checkNotificationAuthorization { status in
            DispatchQueue.main.async {
                self.handleAuthorizationStatus(status)
            }
        }
    }
    
    deinit {
        // 옵저버 제거
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func checkNotificationAuthorization(completion: @escaping (UNAuthorizationStatus) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    private func handleAuthorizationStatus(_ status: UNAuthorizationStatus) {
        if case .authorized = status {
            listener?.request(.allowed)
        }
    }
}

extension AuthorizationDeniedViewController: AuthorizationDeniedViewListener {
    func action(_ action: AuthorizationDeniedView.Action) {
        switch action {
        case .backButtonTapped:
            listener?.request(.back)
        case .laterButtonTapped:
            listener?.request(.later)
        case .settingButtonTapped:
            goToSettings()
        }
    }
}
