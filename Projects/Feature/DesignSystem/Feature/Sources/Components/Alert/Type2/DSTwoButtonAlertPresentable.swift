//
//  DSTwoButtonAlertPresentable.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 1/20/25.
//

import UIKit

public protocol DSTwoButtonAlertPresentable: AnyObject {
    
    var alertTransitionDelegate: UIViewControllerTransitioningDelegate? { get set }
    
    func presentAlert(presentingController: UIViewController, listener: DSTwoButtonAlertViewControllerListener, config: DSTwoButtonAlert.Config)
    
    func dismissAlert(presentingController viewController: UIViewController, completion: (()->Void)?)
}

public extension DSTwoButtonAlertPresentable {
    
    func presentAlert(presentingController viewController: UIViewController, listener: DSTwoButtonAlertViewControllerListener, config: DSTwoButtonAlert.Config) {
        
        let alertController = DSTwoButtonAlertViewController(config: config)
        alertController.listener = listener
        
        let transitionDelegate = CustomAlertTranstionDelegate()
        self.alertTransitionDelegate = transitionDelegate
        alertController.transitioningDelegate = transitionDelegate
        alertController.modalPresentationStyle = .custom
        viewController.present(alertController, animated: true)
    }
    
    func dismissAlert(presentingController viewController: UIViewController, completion: (()->Void)?=nil) {
        if viewController.presentedViewController is DSTwoButtonAlertViewController {
            viewController.dismiss(animated: true, completion: completion)
        }
    }
}


// MARK: CustomAlertTranstionDelegate
fileprivate final class CustomAlertTranstionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CustomAlertDismissAnimation()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CustomAlertPresentAnimation()
    }
}


// MARK: CustomAlertPresentAnimation
fileprivate class CustomAlertPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let containerView = transitionContext.containerView
        
        toView.alpha = 0
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = 1
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}


// MARK: CustomAlertDismissAnimation
fileprivate class CustomAlertDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.alpha = 0
        }) { _ in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
