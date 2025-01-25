//
//  DSTwoButtonAlertViewController.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 1/20/25.
//

import UIKit

public protocol DSTwoButtonAlertViewControllerListener: AnyObject {
    
    func action(_ action: DSTwoButtonAlertViewController.Action)
}

public final class DSTwoButtonAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    // Action
    public enum Action {
        case leftButtonClicked
        case rightButtonClicked
    }
    
    // Listener
    public weak var listener: DSTwoButtonAlertViewControllerListener?
    
    
    // Sub views
    private let alertView: DSTwoButtonAlert
    
    
    public init(config: DSTwoButtonAlert.Config) {
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
        alertView.leftButton.buttonAction = { [weak self] in
            self?.listener?.action(.leftButtonClicked)
        }
        alertView.rightButton.buttonAction = { [weak self] in
            self?.listener?.action(.rightButtonClicked)
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
public extension DSTwoButtonAlertViewController {
    
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


#Preview {
    DSTwoButtonAlertViewController(config: .init(
        titleText: "이것은 타이틀 입니다.",
        subTitleText: "이것은 서브타이틀 입니다.",
        leftButtonText: "왼쪽",
        rightButtonText: "오른쪽"
    ))
}
