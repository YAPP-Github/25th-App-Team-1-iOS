//
//  DSAlertDismissable.swift
//  DesignSystem
//
//  Created by choijunios on 2/12/25.
//

import UIKit

public protocol DSAlertDismissable {
    func dismissAlert(presentingController viewController: UIViewController, completion: (()->Void)?)
}

public extension DSAlertDismissable {
    func dismissAlert(presentingController viewController: UIViewController, completion: (()->Void)?=nil) {
        if viewController.presentedViewController is DSTwoButtonAlertViewController ||
            viewController.presentedViewController is DSButtonAlertViewController {
            viewController.dismiss(animated: true, completion: completion)
        }
    }
}
