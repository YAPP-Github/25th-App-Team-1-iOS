//
//  ShakeMissionWorkingInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import FeatureUIDependencies

import RIBs
import RxSwift

protocol ShakeMissionWorkingRouting: ViewableRouting {
    func request(_ request: ShakeMissionWorkingRoutingRequest)
}
enum ShakeMissionWorkingRoutingRequest {
    case presentAlert(DSTwoButtonAlert.Config)
    case dismissAlert(completion: (()->Void)?=nil)
}


protocol ShakeMissionWorkingPresentable: Presentable {
    var listener: ShakeMissionWorkingPresentableListener? { get set }
    
    func request(_ request: ShakeMissionWorkingInteractorRequest)
}

// Mission flow
enum MissionFlowState: Equatable {
    case initial(successShakeCount: Int)
    case guide
    case start
    case success
}

// Shake motion
enum ShakeMotionDetactorState {
    case start, stop, pause, resume
}

// Haptik feedback
enum HapticGeneratorAction {
    case prepare
    case occur
    case stop
}

enum ShakeMissionWorkingInteractorRequest {
    case missionFlow(MissionFlowState)
    case shakeMotionDetactor(ShakeMotionDetactorState)
    case hapticGeneratorAction(HapticGeneratorAction)
    case updateSuccessCount(Int)
    case updateMissionProgressPercent(Double)
}


public protocol ShakeMissionWorkingListener: AnyObject {
    func exitShakeMissionWorkingPage(isSucceeded: Bool)
}

final class ShakeMissionWorkingInteractor: PresentableInteractor<ShakeMissionWorkingPresentable>, ShakeMissionWorkingInteractable, ShakeMissionWorkingPresentableListener {

    weak var router: ShakeMissionWorkingRouting?
    weak var listener: ShakeMissionWorkingListener?
    
    
    // Mission configuration
    private let successShakeCount = 10
    private var currentShakeCount = 0
    private var isMissionSuccess = false
    
    
    // State
    private var currentMissionFlow: MissionFlowState?
    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ShakeMissionWorkingPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}


// MARK: ShakeMissionWorkingPresentableListener
extension ShakeMissionWorkingInteractor {
    
    func request(_ request: ShakeMissionWorkingPresenterRequest) {
        switch request {
        case .initializeMission:
            let nextFlow: MissionFlowState = .initial(successShakeCount: successShakeCount)
            self.currentMissionFlow = nextFlow
            presenter.request(.missionFlow(nextFlow))
        case .missionPageIsReady:
            let nextFlow: MissionFlowState = .guide
            self.currentMissionFlow = nextFlow
            presenter.request(.missionFlow(nextFlow))
            presenter.request(.hapticGeneratorAction(.prepare))
            presenter.request(.shakeMotionDetactor(.start))
        case .missionGuideFinished:
            let nextFlow: MissionFlowState = .start
            self.currentMissionFlow = nextFlow
            presenter.request(.missionFlow(nextFlow))
        case .missionSuccessEventFinished:
            listener?.exitShakeMissionWorkingPage(isSucceeded: true)
            
        case .exitPage:
            
            // 미션이 성공 상태인 경우 Alert표출 금지
            if isMissionSuccess { return }
            
            // 모션감지 퍼즈
            presenter.request(.shakeMotionDetactor(.pause))
            
            // Alert 표시
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "나가면 운세를 받을 수 없어요",
                subTitleText: "미션을 수행하지 않고 나가시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "나가기",
                leftButtonTapped: { [weak self] in
                    guard let self else { return }
                    // 모션감지기 재동작
                    presenter.request(.shakeMotionDetactor(.resume))
                    router?.request(.dismissAlert())
                }, rightButtonTapped: { [weak self] in
                    guard let self else { return }
                    let completion = { [weak self] in
                        guard let self else { return }
                        listener?.exitShakeMissionWorkingPage(isSucceeded: false)
                    }
                    router?.request(.dismissAlert(completion: completion))
                }
            )
            router?.request(.presentAlert(alertConfig))
            
        case .shakeIsDetected:
            if currentMissionFlow == .guide {
                // 가이드 상태에서 미션을 진행한 경우
                let nextFlow: MissionFlowState = .start
                self.currentMissionFlow = nextFlow
                presenter.request(.missionFlow(nextFlow))
            }
            
            if currentShakeCount < successShakeCount {
                // 성공 횟수를 증가
                self.currentShakeCount += 1
                
                // 성공 횟수 UI업데이트
                presenter.request(.updateSuccessCount(currentShakeCount))
                
                // Percent UI업데이트
                let percent = Double(currentShakeCount)/Double(successShakeCount)
                presenter.request(.updateMissionProgressPercent(percent))
                
                // 햅틱 Feedback실행
                presenter.request(.hapticGeneratorAction(.occur))
            }
            
            if !isMissionSuccess, currentShakeCount >= successShakeCount {
                self.isMissionSuccess = true
                presenter.request(.missionFlow(.success))
                presenter.request(.shakeMotionDetactor(.stop))
                presenter.request(.hapticGeneratorAction(.stop))
            }
        }
    }
}
