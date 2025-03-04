//
//  TapMissionWorkingViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import RIBs
import RxSwift
import UIKit

enum TapMissionWorkingPresenterRequest {
    case initializeMission
    case viewIsReadyForMission
    case countUpTap
    case exitPage
    case missionGuideFinished
    case missionSuccessEventFinished
}

protocol TapMissionWorkingPresentableListener: AnyObject {
    func request(_ request: TapMissionWorkingPresenterRequest)
}

final class TapMissionWorkingViewController: UIViewController, TapMissionWorkingPresentable, TapMissionWorkingViewControllable, TapMissionWorkingViewListener {
    
    // Impact generator
    private var impactFeedBackGenerator: UIImpactFeedbackGenerator?

    private(set) var mainView: TapMissionWorkingView!
    
    weak var listener: TapMissionWorkingPresentableListener?
    
    override func loadView() {
        let mainView = TapMissionWorkingView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.initializeMission)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.request(.viewIsReadyForMission)
    }
}


// MARK: TapMissionWorkingPresentable
extension TapMissionWorkingViewController {
    func request(_ request: TapMissionWorkingInteractorRequest) {
        switch request {
        case .startMissionFlow(let flow):
            handleMissionFlow(flow)
        case .hapticGeneratorAction(let action):
            handleHaptic(action)
        case .updateSuccessCount(let newCount):
            mainView
                .update(.playTapAnim)
                .update(.countText("\(newCount)"))
        case .updateMissionProgressPercent(let newPercent):
            mainView.update(.missionProgress(newPercent))
        }
    }
    
    private func handleMissionFlow(_ flow: TapMissionFlow) {
        switch flow {
        case .initial(let successTapCount):
            let titleText = "\(successTapCount)회를 흔들어야 운세를 받아요"
            mainView
                .update(.missionProgress(0.0))
                .update(.countText("0"))
                .update(.titleText(titleText))
        case .guide:
            mainView.update(.missionFlow(.guide))
        case .start:
            mainView.update(.missionFlow(.working))
        case .success:
            mainView.update(.missionFlow(.success))
        }
    }
    
    private func handleHaptic(_ action: HapticGeneratorAction) {
        switch action {
        case .prepare:
            self.impactFeedBackGenerator = .init(style: .heavy)
            self.impactFeedBackGenerator?.prepare()
        case .occur:
            self.impactFeedBackGenerator?.impactOccurred()
        case .stop:
            self.impactFeedBackGenerator = nil
        }
    }
}


// MARK: TapMissionWorkingViewListener
extension TapMissionWorkingViewController {
    func action(_ action: TapMissionWorkingView.Action) {
        switch action {
        case .letterIsTapped:
            listener?.request(.countUpTap)
        case .exitButtonClicked:
            listener?.request(.exitPage)
        case .missionGuideAnimationCompleted:
            listener?.request(.missionGuideFinished)
        case .missionSuccessAnimationCompleted:
            listener?.request(.missionSuccessEventFinished)
        }
    }
}
