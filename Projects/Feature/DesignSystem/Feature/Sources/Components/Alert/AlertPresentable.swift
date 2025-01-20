//
//  AlertPresentable.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 1/20/25.
//

import UIKit

public protocol AlertPresentable: AnyObject {
    
    var alertTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }
    
    func presentAlert(presentingController: UIViewController, listener: DSTwoButtonAlertViewControllerListener, config: DSTwoButtonAlert.Config)
    
    func dismissAlert(presentingController viewController: UIViewController, completion: (()->Void)?)
}
