//
//  DSButtonAlertViewController.swift
//  FeatureDesignSystem
//
//  Created by ever on 2/7/25.
//

import UIKit

public protocol DSButtonAlertViewControllerListener: AnyObject {
    
    func action(_ action: DSButtonAlertViewController.Action)
}

public final class DSButtonAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    // Action
    public enum Action {
        case buttonClicked
    }
    
    // Listener
    public weak var listener: DSButtonAlertViewControllerListener?
    
    
    // Sub views
    private let alertView: DSButtonAlert
    
    
    public init(config: DSButtonAlert.Config) {
        self.alertView = .init(config: config)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { nil }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        
        // view
        view.backgroundColor = UIColor(hex: "#17191F").withAlphaComponent(0.9)
        
        // alertView
        let configAction = alertView.button.buttonAction
        alertView.button.buttonAction = { [weak self] in
            configAction?()
            self?.listener?.action(.buttonClicked)
        }
        view.addSubview(alertView)
    }
    
    private func setupLayout() {
        
        // alertView
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(33.5)
        }
    }
}

// MARK: UIViewControllerTransitioningDelegate
public extension DSButtonAlertViewController {
    
    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CustomAlertDismissAnimation()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        CustomAlertPresentAnimation()
    }
}
    

// MARK: CustomAlertPresentAnimation
fileprivate final class CustomAlertPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
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
fileprivate final class CustomAlertDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
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
