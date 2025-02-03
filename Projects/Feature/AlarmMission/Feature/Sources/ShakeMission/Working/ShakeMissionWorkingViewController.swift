//
//  ShakeMissionWorkingViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs
import RxSwift
import UIKit

import FeatureUIDependencies

import CoreMotion

protocol ShakeMissionWorkingPresentableListener: AnyObject {
    
    func request(_ request: ShakeMissionWorkingPresenterRequest)
}

enum ShakeMissionWorkingPresenterRequest {
    
    case missionPageIsReady
    case missionGuideFinished
    case missionSuccessEventFinished
    
    case shakeIsDetected
    case presentExitAlert(DSTwoButtonAlert.Config)
}

final class ShakeMissionWorkingViewController: UIViewController, ShakeMissionWorkingPresentable, ShakeMissionWorkingViewControllable, ShakeMissionWorkingViewListener {

    // Shake motion effect
    private var shakeDetecter: ShakeDetecter?
    private var impactFeedBackGenerator: UIImpactFeedbackGenerator?
    
    
    private(set) var mainView: ShakeMissionWorkingView!
    
    weak var listener: ShakeMissionWorkingPresentableListener?
    
    override func loadView() {
        let mainView = ShakeMissionWorkingView()
        self.mainView = mainView
        self.view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.request(.missionPageIsReady)
    }
}


// MARK: ShakeMissionWorkingPresentable
extension ShakeMissionWorkingViewController {
    
    func request(_ request: ShakeMissionWorkingInteractorRequest) {
        switch request {
        case .missionFlow(let state):
            
            switch state {
            case .guide(let successShakeCount):
                mainView
                    .update(progress: 0.0)
                    .update(countText: "0")
                    .update(titleText: "\(successShakeCount)회를 흔들어야 운세를 받아요")
                    .update(missionState: .guide)
            case .start:
                mainView.update(missionState: .working)
            case .success:
                mainView.update(missionState: .success)
            }
            
        case .updateSuccessCount(let newCount):
            mainView.update(countText: "\(newCount)")
            
        case .updateMissionProgressPercent(let newPercent):
            mainView.update(progress: newPercent)
            
        case .shakeMotionDetactor(let state):
            switch state {
            case .start:
                let shakeDetector = ShakeDetecter(shakeThreshold: 1.5, detectionInterval: 0.25) { [weak self] in
                    guard let self else { return }
                    listener?.request(.shakeIsDetected)
                }
                self.shakeDetecter = shakeDetector
                shakeDetector.startDetection()
            case .stop:
                self.shakeDetecter?.stopDetection()
                self.shakeDetecter = nil
            case .pause:
                self.shakeDetecter?.stopDetection()
            case .resume:
                self.shakeDetecter?.startDetection()
            }
            
        case .hapticGeneratorAction(let action):
            switch action {
            case .prepare:
                self.impactFeedBackGenerator = .init(style: .medium)
                self.impactFeedBackGenerator?.prepare()
            case .occur:
                self.impactFeedBackGenerator?.impactOccurred()
            case .stop:
                self.impactFeedBackGenerator = nil
            }
            
        }
    }
}


// MARK: ShakeMissionWorkingViewListener
extension ShakeMissionWorkingViewController {
    
    func action(_ action: ShakeMissionWorkingView.Action) {
        switch action {
        case .exitButtonClicked:
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "나가면 운세를 받을 수 없어요",
                subTitleText: "미션을 수행하지 않고 나가시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "나가기"
            )
            listener?.request(.presentExitAlert(alertConfig))
        case .missionGuideAnimationCompleted:
            listener?.request(.missionGuideFinished)
        case .missionSuccessAnimationCompleted:
            listener?.request(.missionSuccessEventFinished)
        }
    }
}

#Preview {
    ShakeMissionWorkingViewController()
}
