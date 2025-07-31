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
    func request(_ request: ConfigureMissionForAlarmPresenterRequest)
}

enum ConfigureMissionForAlarmPresenterRequest {
    case dimmedBackgroundIsTapped
    case addMissionButtonIsTapped
    case missionChangeButtonTapped
    case missionConditionChangeButtonTapped
    case missionDeleteButtonTapped
    case missionIsSelected(item: MissionItemRenderObject)
    case missionConditionIsSelected(index: Int)
    case missionCompleteButtonTapped
    
    case exitButtonTapped
    case prevButtonTapped
    
    case missionPreviewButtonTapped
    case missionSaveButtonTapped
}

final class ConfigureMissionForAlarmViewController: UIViewController, ConfigureMissionForAlarmPresentable, ConfigureMissionForAlarmViewControllable {

    weak var listener: ConfigureMissionForAlarmPresentableListener?
    
    // UI
    private let dimmedBackgroundView: UIView = .init()
    private let contentsBaseView: RoundBaseView = .init()
    private var pages: [Page: UIView] = [:]
    
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}


// MARK: Setup
private extension ConfigureMissionForAlarmViewController {
    func setupUI() {
        
        // view
        view.isOpaque = false
        
        
        // dimmedBackgroundView
        dimmedBackgroundView.backgroundColor = R.Color.dimmed.withAlphaComponent(0.8)
        dimmedBackgroundView.addGestureRecognizer(backgroundTapGesture)
        view.addSubview(dimmedBackgroundView)
        
        
        // missionSelectionIntroView
        view.addSubview(contentsBaseView)
    }
    
    
    func setupLayout() {
        
        // dimmedBackgroundView
        dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        // missionSelectionIntroView
        contentsBaseView.snp.makeConstraints { make in
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
        listener?.request(.dimmedBackgroundIsTapped)
    }
    
    
    func present(page: Page) {
        var pageView = pages[page]
        if pageView == nil {
            pageView = create(page: page)
        }
        contentsBaseView.change(contentsView: pageView!)
    }
    
    
    func get<T>(page: Page) -> T {
        var pageView = pages[page]
        if pageView == nil {
            pageView = create(page: page)
        }
        return pageView as! T
    }
    
    
    func create(page: Page) -> UIView {
        let pageView: UIView
        switch page {
        case .currentMissionPage:
            
            let view = CurrentMissionPage()
            view.pageAction = { [unowned self] in
                switch $0 {
                case .currentMissionItemTapped:
                    listener?.request(.missionConditionChangeButtonTapped)
                case .deleteMissionButtonTapped:
                    listener?.request(.missionDeleteButtonTapped)
                case .changeMissionButtonTapped:
                    listener?.request(.missionChangeButtonTapped)
                case .completeButtonTapped:
                    listener?.request(.missionCompleteButtonTapped)
                }
            }
            pageView = view
            
        case .addMissionPage:
            
            let view = AddMissionPage()
            view.pageAction = { [unowned self] in
                switch $0 {
                case .addNewMissionButtonTapped:
                    listener?.request(.addMissionButtonIsTapped)
                }
            }
            pageView = view
            
        case .missionConditionSettingPage:
            
            let view = MissionConditionSettingPage()
            view.pageAction = { [unowned self] in
                switch $0 {
                case .exitButtonTapped:
                    listener?.request(.exitButtonTapped)
                case .prevButtonTapped:
                    listener?.request(.prevButtonTapped)
                case .conditionButtonIsTapped(index: let index):
                    listener?.request(.missionConditionIsSelected(index: index))
                case .previewButtonIsTapped:
                    listener?.request(.missionPreviewButtonTapped)
                case .saveButtonIsTapped:
                    listener?.request(.missionSaveButtonTapped)
                }
            }
            pageView = view
            
        case .missionListPage:
            
            let view = MissionListPage()
            view.pageAction = { [unowned self] in
                switch $0 {
                case .exitButtonTapped:
                    listener?.request(.exitButtonTapped)
                case .prevButtonTapped:
                    listener?.request(.prevButtonTapped)
                case .missionIsSelected(item: let item):
                    listener?.request(.missionIsSelected(item: item))
                }
            }
            pageView = view
        }
        self.pages[page] = pageView
        return pageView
    }
}


// MARK: Update
extension ConfigureMissionForAlarmViewController {
    func update(_ update: ConfigureMissionForAlarmPresentableUpdate) {
        switch update {
        case .present(let page):
            switch page {
            case .currentMissionPage(let item, let conditionIndex):
                
                let currentMissionPage: CurrentMissionPage = get(page: .currentMissionPage)
                currentMissionPage.update(item: item, conditionIndex: conditionIndex)
                present(page: .currentMissionPage)
                
            case .missionConditionSettingPage(let item, let conditionIndex):
                
                let missionConditionSettingPage: MissionConditionSettingPage = get(page: .missionConditionSettingPage)
                missionConditionSettingPage.update(.changeMissionItem(item: item))
                missionConditionSettingPage.update(.selectCondition(index: conditionIndex))
                present(page: .missionConditionSettingPage)
                
            case .missionListPage(let items):
                
                let missionListPage: MissionListPage = get(page: .missionListPage)
                missionListPage.update(missionItems: items)
                present(page: .missionListPage)
                
            case .addMissionPage:
                
                present(page: .addMissionPage)
            }
            
        case .selectMissionCondition(let index):
            
            let pageView: MissionConditionSettingPage = get(page: .missionConditionSettingPage)
            pageView.update(.selectCondition(index: index))
        }
    }
}


// MARK: Presentation & Dismissal
private extension ConfigureMissionForAlarmViewController {
    
    func startPresentationAnimation(duration: TimeInterval, completion: @escaping () -> Void) {
        
        // #1. Initial State
        dimmedBackgroundView.alpha = 0
        
        self.view.layoutIfNeeded()
        let startTopInset = UIScreen.main.bounds.height - self.contentsBaseView.bounds.height
        contentsBaseView.layer.frame.origin.y = UIScreen.main.bounds.height
        
        
        // #2. Animate
        UIView.animate(withDuration: duration) {
            self.dimmedBackgroundView.alpha = 1
            self.contentsBaseView.frame.origin.y = startTopInset
        } completion: { _ in
            completion()
        }
    }
    
    func startDismissalAnimation(duration: TimeInterval, completion: @escaping () -> Void) {
        
        // #1. Animate
        UIView.animate(withDuration: duration) {
            self.dimmedBackgroundView.alpha = 0
            self.contentsBaseView.layer.frame.origin.y = UIScreen.main.bounds.height
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
        
        fromVC.startDismissalAnimation(duration: animationDuration) {
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}



#Preview(traits: .defaultLayout, body: {
    ConfigureMissionForAlarmViewController()
})
