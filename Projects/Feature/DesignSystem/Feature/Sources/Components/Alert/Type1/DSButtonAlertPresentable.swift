//
//  DSButtonAlertPresentable.swift
//  FeatureDesignSystem
//
//  Created by ever on 2/7/25.
//

import UIKit

public protocol DSButtonAlertPresentable: DSAlertDismissable {
    func presentAlert(presentingController viewController: UIViewController, listener: DSButtonAlertViewControllerListener?, config: DSButtonAlert.Config)
}

public extension DSButtonAlertPresentable {
    
    func presentAlert(presentingController viewController: UIViewController, listener: DSButtonAlertViewControllerListener?, config: DSButtonAlert.Config) {
        
        let alertController = DSButtonAlertViewController(config: config)
        alertController.listener = listener
        
        alertController.transitioningDelegate = alertController
        alertController.modalPresentationStyle = .custom
        viewController.present(alertController, animated: true)
    }
}
