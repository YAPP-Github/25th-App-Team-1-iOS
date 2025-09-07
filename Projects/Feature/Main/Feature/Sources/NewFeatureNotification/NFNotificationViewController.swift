//
//  NFNotificationViewController.swift
//  FeatureMain
//
//  Created by choijunios on 9/7/25.
//

import RIBs
import RxSwift
import UIKit
import FeatureResources
import FeatureDesignSystem
import SnapKit

protocol NFNotificationPresentableListener: AnyObject {
    func request(_ request: NFNotificationPresentableListenerRequest)
}

enum NFNotificationPresentableListenerRequest {
    case viewDidLoad
    case backgroundTapped
    case closeButtonTapped
    case dontShowAgainButtonTapped
}

final class NFNotificationViewController: UIViewController, NFNotificationPresentable, NFNotificationViewControllable {
    
    private lazy var dimmedBackgroundView: UIView = .init()
    private lazy var containerView: UIView = .init()
    private lazy var imageGuideView: UIImageView = .init()
    private lazy var buttonStack: UIStackView = .init()
    private lazy var dontShowAgainButton: DSLabelButton = .init(config: .init(font: .body1SemiBold, textColor: R.Color.white100, alignment: .center))
    private lazy var closeButton: DSLabelButton = .init(config: .init(font: .body1SemiBold, textColor: R.Color.white100, alignment: .center))
    
    // Gesture
    private let backgroundTapGesture: UITapGestureRecognizer = .init()

    // Listener
    weak var listener: NFNotificationPresentableListener?
    
    // Trasition
    private var vcTransitionDelegate: VCTransitionDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.vcTransitionDelegate = VCTransitionDelegate()
        self.transitioningDelegate = vcTransitionDelegate
    }
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupGesture()
        
        listener?.request(.viewDidLoad)
    }
}

private extension NFNotificationViewController {
    func setupUI() {
        
        // view
        view.isOpaque = false
        
        // dimmedBackgroundView
        dimmedBackgroundView.backgroundColor = R.Color.dimmed.withAlphaComponent(0.8)
        dimmedBackgroundView.addGestureRecognizer(backgroundTapGesture)
        view.addSubview(dimmedBackgroundView)
        
        // containerView
        view.addSubview(containerView)
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = R.Color.gray800
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // imageGuideView
        imageGuideView.clipsToBounds = true
        imageGuideView.contentMode = .scaleAspectFit
        containerView.addSubview(imageGuideView)
        
        // buttonStack
        containerView.addSubview(buttonStack)
        [dontShowAgainButton, closeButton].forEach {
            buttonStack.addArrangedSubview($0)
        }
        
        // dontShowAgainButton
        dontShowAgainButton.update(titleText: "다시보지 않기")
        
        // closeButton
        closeButton.update(titleText: "닫기")
    }
    
    func setupLayout() {
        // dimmedBackgroundView
        dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // containerView
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // imageGuideView
        imageGuideView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        // buttonStack
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(imageGuideView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.height.equalTo(54)
        }
    }
    
    func setupGesture() {
        backgroundTapGesture.addTarget(self, action: #selector(onBackgroundTapGestureTapped(_:)))
    }
    
    @objc
    func onBackgroundTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        listener?.request(.backgroundTapped)
    }
}

extension NFNotificationViewController {
    func request(_ request: NFNotificationPresentableRequest) {
        switch request {
        case let .presentGuideImage(image):
            imageGuideView.image = image
            let aspect = image.size.height / image.size.width
            imageGuideView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(imageGuideView.snp.width).multipliedBy(aspect)
            }
            view.setNeedsLayout()
        }
    }
}

extension NFNotificationViewController {
    func startPresentationAnimation(duration: TimeInterval, completion: @escaping () -> Void) {
        // #1. Initial State
        view.alpha = 0
        
        // #2. Animate
        UIView.animate(withDuration: duration) {
            self.view.alpha = 1
        } completion: { _ in
            completion()
        }
    }
    
    func startDismissalAnimation(duration: TimeInterval, completion: @escaping () -> Void) {
        // #1. Animate
        UIView.animate(withDuration: duration) {
            self.dimmedBackgroundView.alpha = 0
            self.containerView.layer.frame.origin.y = UIScreen.main.bounds.height
        } completion: { _ in
            completion()
        }
    }
}

// MARK: Transition
fileprivate final class VCTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(
        forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        VCDismissalAnimator()
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        VCPresentationAnimator()
    }
}

fileprivate final class VCPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animationDuration: TimeInterval = 0.3
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) as? NFNotificationViewController else { return }
        let container = transitionContext.containerView
        container.addSubview(toVC.view)
        toVC.startPresentationAnimation(duration: animationDuration) {
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
}


fileprivate final class VCDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animationDuration: TimeInterval = 0.3
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? NFNotificationViewController else { return }
        
        fromVC.startDismissalAnimation(duration: animationDuration) {
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}

#Preview {
    NFNotificationViewController()
}
