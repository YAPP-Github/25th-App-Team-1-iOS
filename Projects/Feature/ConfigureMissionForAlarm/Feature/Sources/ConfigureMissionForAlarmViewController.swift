//
//  ConfigureMissionForAlarmViewController.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import UIKit

import FeatureUIDependencies

import RIBs
import RxSwift

protocol ConfigureMissionForAlarmPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ConfigureMissionForAlarmViewController: UIViewController, ConfigureMissionForAlarmPresentable, ConfigureMissionForAlarmViewControllable {

    weak var listener: ConfigureMissionForAlarmPresentableListener?
    
    // UI
    private let dimmedBackgroundView: UIView = .init()
    private let missionSelectionIntroView: MissionSelectionIntroView = .init()
    private let missionSelectionIntroViewTopInset: CGFloat = 212
    
    
    // Gesture
    private let backgroundTapGesture: UITapGestureRecognizer = .init()
    
    
    // Trasition
    private var vcTransitionDelegate: VCTransitionDelegate?
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.vcTransitionDelegate = VCTransitionDelegate()
        self.transitioningDelegate = vcTransitionDelegate
        
        setupPresentationStyle()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGesture()
        setupLayout()
    }
}


private extension ConfigureMissionForAlarmViewController {
    func setupUI() {
        
        // view
        view.isOpaque = false
        
        
        // dimmedBackgroundView
        dimmedBackgroundView.backgroundColor = R.Color.dimmed.withAlphaComponent(0.8)
        dimmedBackgroundView.addGestureRecognizer(backgroundTapGesture)
        view.addSubview(dimmedBackgroundView)
        
        
        // missionSelectionIntroView
        missionSelectionIntroView.listener = self
        view.addSubview(missionSelectionIntroView)
    }
    
    
    func setupLayout() {
        
        // dimmedBackgroundView
        dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        // missionSelectionIntroView
        missionSelectionIntroView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(missionSelectionIntroViewTopInset)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    func setupGesture() {
        backgroundTapGesture.addTarget(self, action: #selector(onBackgroundTapped(_:)))
    }
    
    
    func setupPresentationStyle() {
        self.modalPresentationStyle = .overFullScreen
    }
    
    
    @objc
    func onBackgroundTapped(_ recog: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true)
    }
}


// MARK: MissionSelectionIntroViewListener
extension ConfigureMissionForAlarmViewController: MissionSelectionIntroViewListener {
    func request(_ action: MissionSelectionIntroViewAction) {
        switch action {
        case .addNewMission:
            break
        }
    }
}



// MARK: Presentation
private extension ConfigureMissionForAlarmViewController {
    
    func startPresentationAnimation(duration: TimeInterval, completion: @escaping () -> Void) {
        
        // #1. Initial State
        dimmedBackgroundView.alpha = 0
        missionSelectionIntroView.layer.frame.origin.y = UIScreen.main.bounds.height
        
        
        // #2. Animate
        UIView.animate(withDuration: duration) {
            self.dimmedBackgroundView.alpha = 1
            self.missionSelectionIntroView.frame.origin.y = self.missionSelectionIntroViewTopInset
        } completion: { _ in
            completion()
        }
    }
    
    func startDismissalAnimation(duration: TimeInterval, completion: @escaping () -> Void) {
        
        // #1. Animate
        UIView.animate(withDuration: duration) {
            self.dimmedBackgroundView.alpha = 0
            self.missionSelectionIntroView.layer.frame.origin.y = UIScreen.main.bounds.height
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
        guard let toVC = transitionContext.viewController(forKey: .to) as? ConfigureMissionForAlarmViewController else { return }
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
        guard let fromVC = transitionContext.viewController(forKey: .from) as? ConfigureMissionForAlarmViewController else { return }
        let container = transitionContext.containerView
        
        fromVC.startDismissalAnimation(duration: animationDuration) {
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}



#Preview(traits: .defaultLayout, body: {
    ConfigureMissionForAlarmViewController()
})
