//
//  ShakeMissionWorkingInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 1/20/25.
//

import FeatureDesignSystem

import RIBs
import RxSwift

protocol ShakeMissionWorkingRouting: ViewableRouting {
    func request(_ request: ShakeMissionWorkingRoutingRequest)
}
enum ShakeMissionWorkingRoutingRequest {
    case presentAlert(DSTwoButtonAlert.Config, DSTwoButtonAlertViewControllerListener)
    case dismissAlert(completion: (()->Void)?=nil)
}


protocol ShakeMissionWorkingPresentable: Presentable {
    var listener: ShakeMissionWorkingPresentableListener? { get set }
    
    func request(_ request: ShakeMissionWorkingInteractorRequest)
}
enum ShakeMissionWorkingInteractorRequest {
    
    // Mission flow
    enum MissionFlowState {
        case guide(successShakeCount: Int)
        case start
        case success
    }
    case missionFlow(MissionFlowState)
    
    // Shake motion
    enum ShakeMotionDetactorState {
        case start, stop, pause, resume
    }
    case shakeMotionDetactor(ShakeMotionDetactorState)
    
    // Haptik feedback
    enum HapticGeneratorAction {
        case prepare
        case occur
        case stop
    }
    case hapticGeneratorAction(HapticGeneratorAction)
    
    // UI update
    case updateSuccessCount(Int)
    case updateMissionProgressPercent(Double)
}


protocol ShakeMissionWorkingListener: AnyObject {
    func exitShakeMissionWorkingPage()
}

final class ShakeMissionWorkingInteractor: PresentableInteractor<ShakeMissionWorkingPresentable>, ShakeMissionWorkingInteractable, ShakeMissionWorkingPresentableListener, DSTwoButtonAlertViewControllerListener {

    weak var router: ShakeMissionWorkingRouting?
    weak var listener: ShakeMissionWorkingListener?
    
    
    // Mission configuration
    private let successShakeCount = 10
    private var currentShakeCount = 0
    private var isMissionSuccess = false
    

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
        case .missionPageIsReady:
            presenter.request(.hapticGeneratorAction(.prepare))
            presenter.request(.missionFlow(.guide(successShakeCount: 10)))
        case .missionGuideFinished:
            presenter.request(.missionFlow(.start))
            presenter.request(.shakeMotionDetactor(.start))
        case .missionSuccessEventFinished:
            
            // MARK: 임시 조치, 변경예정
            listener?.exitShakeMissionWorkingPage()
            
        case .presentExitAlert(let config):
            router?.request(.presentAlert(config, self))
        case .shakeIsDetected:
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


// MARK: DSTwoButtonAlertViewControllerListener
extension ShakeMissionWorkingInteractor {
    func action(_ action: DSTwoButtonAlertViewController.Action) {
        switch action {
        case .leftButtonClicked:
            router?.request(.dismissAlert())
        case .rightButtonClicked:
            let completion = { [weak self] in
                guard let self else { return }
                listener?.exitShakeMissionWorkingPage()
            }
            router?.request(.dismissAlert(completion: completion))
        }
    }
}
