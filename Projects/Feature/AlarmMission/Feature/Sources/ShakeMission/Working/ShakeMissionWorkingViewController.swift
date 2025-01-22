//
//  ShakeMissionWorkingViewController.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import RIBs
import RxSwift
import UIKit

import FeatureDesignSystem

import CoreMotion

protocol ShakeMissionWorkingPresentableListener: AnyObject {
    
    func request(_ request: ShakeMissionWorkingPresenterRequest)
}

enum ShakeMissionWorkingPresenterRequest {
    
    case startMission
    case shakeIsDetected
    case presentExitAlert(DSTwoButtonAlert.Config)
}

final class ShakeMissionWorkingViewController: UIViewController, ShakeMissionWorkingPresentable, ShakeMissionWorkingViewControllable, ShakeMissionWorkingViewListener {

    // Shake motion effect
    private var shakeDetecter: ShakeDetecter?
    private let impactFeedBackGenerator: UIImpactFeedbackGenerator = .init(style: .medium)
    
    
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
        impactFeedBackGenerator.prepare()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.request(.startMission)
    }
}


// MARK: ShakeMissionWorkingPresentable
extension ShakeMissionWorkingViewController {
    
    func request(_ request: ShakeMissionWorkingInteractorRequest) {
        switch request {
        case .startShakeMissionFlow(let successShakeCount):
            // 가이드 플로우 시작
            mainView
                .update(progress: 0.0)
                .update(countText: "0")
                .update(titleText: "\(successShakeCount)회를 흔들어야 운세를 받아요")
                .update(missionState: .guide) { [weak self] in
                    guard let self else { return }
                    // Guide --> Working(쉐이킹 감지)
                    mainView.update(missionState: .working)
                    
                    // 모션감지
                    let shakeDetector = ShakeDetecter(shakeThreshold: 1.5, detectionInterval: 0.25) { [weak self] in
                        guard let self else { return }
                        listener?.request(.shakeIsDetected)
                    }
                    self.shakeDetecter = shakeDetector
                    shakeDetector.startDetection()
                }
        case .updateSuccessCount(let newCount):
            mainView.update(countText: "\(newCount)")
        case .updateMissionProgressPercent(let newPercent):
            mainView.update(progress: newPercent)
        case .startSuccessFlow:
            // 모션 감지 종료
            self.shakeDetecter?.stopDetection()
            self.shakeDetecter = nil
            
            // 성공 프로우 시작
            mainView.update(missionState: .success)
        case .occurShakeMotionFeedback:
            impactFeedBackGenerator.impactOccurred()
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
        }
    }
}

#Preview {
    ShakeMissionWorkingViewController()
}
