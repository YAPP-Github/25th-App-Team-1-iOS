//
//  DSTwoButtonAlertPresentable.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 1/20/25.
//

import UIKit

public protocol DSTwoButtonAlertPresentable: AlertPresentable { }

public extension DSTwoButtonAlertPresentable {
    
    func presentAlert(presentingController viewController: UIViewController, listener: DSTwoButtonAlertViewControllerListener, config: DSTwoButtonAlert.Config) {
        
        let alertController = DSTwoButtonAlertViewController(config: config)
        alertController.listener = listener
        
        alertController.transitioningDelegate = alertController
        alertController.modalPresentationStyle = .custom
        viewController.present(alertController, animated: true)
    }
    
    func dismissAlert(presentingController viewController: UIViewController, completion: (()->Void)?=nil) {
        if viewController.presentedViewController is DSTwoButtonAlertViewController {
            viewController.dismiss(animated: true, completion: completion)
        }
    }
}
