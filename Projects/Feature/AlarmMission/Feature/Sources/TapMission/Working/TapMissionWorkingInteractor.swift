//
//  TapMissionWorkingInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import FeatureUIDependencies

import RIBs
import RxSwift

protocol TapMissionWorkingRouting: ViewableRouting {
    func request(_ request: TapMissionWorkingRoutingRequest)
}

enum TapMissionWorkingRoutingRequest {
    case presentAlert(DSTwoButtonAlert.Config)
    case dismissAlert(completion: (()->Void)?=nil)
}


protocol TapMissionWorkingPresentable: Presentable {
    var listener: TapMissionWorkingPresentableListener? { get set }
    func request(_ request: TapMissionWorkingInteractorRequest)
}

enum TapMissionWorkingInteractorRequest {
    case startMissionFlow(TapMissionFlow)
    case hapticGeneratorAction(HapticGeneratorAction)
    case updateSuccessCount(Int)
    case updateMissionProgressPercent(Double)
}

protocol TapMissionWorkingListener: AnyObject {
    func request(request: TapMissionWorkingListenerRequest)
}

enum TapMissionWorkingListenerRequest {
    case exitPage(isMissionCompleted: Bool)
}

// Mission flow
enum TapMissionFlow: Equatable {
    case initial(successTapCount: Int)
    case guide
    case start
    case success
}

final class TapMissionWorkingInteractor: PresentableInteractor<TapMissionWorkingPresentable>, TapMissionWorkingInteractable, TapMissionWorkingPresentableListener {

    weak var router: TapMissionWorkingRouting?
    weak var listener: TapMissionWorkingListener?

    // Mission configuration
    private let successTapCount = 10
    
    
    // State
    private var currentTapCount = 0
    private var isMissionSuccess = false
    private var currentMissionFlow: TapMissionFlow?
    
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TapMissionWorkingPresentable) {
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


extension TapMissionWorkingInteractor {
    func request(_ request: TapMissionWorkingPresenterRequest) {
        switch request {
        case .initializeMission:
            let nextFlow: TapMissionFlow = .initial(successTapCount: successTapCount)
            self.currentMissionFlow = nextFlow
            presenter.request(.startMissionFlow(nextFlow))
        case .viewIsReadyForMission:
            let nextFlow: TapMissionFlow = .guide
            self.currentMissionFlow = nextFlow
            presenter.request(.startMissionFlow(nextFlow))
            presenter.request(.hapticGeneratorAction(.prepare))
        case .countUpTap:
            if currentTapCount < successTapCount {
                // 성공 횟수를 증가
                self.currentTapCount += 1
                
                // 성공 횟수 UI업데이트
                presenter.request(.updateSuccessCount(currentTapCount))
                
                // Percent UI업데이트
                let percent = Double(currentTapCount)/Double(successTapCount)
                presenter.request(.updateMissionProgressPercent(percent))
                
                // 햅틱 Feedback실행
                presenter.request(.hapticGeneratorAction(.occur))
            }
            
            if !isMissionSuccess, currentTapCount >= successTapCount {
                self.isMissionSuccess = true
                presenter.request(.startMissionFlow(.success))
                presenter.request(.hapticGeneratorAction(.stop))
            }
            
        case .exitPage:
            
            // 미션이 성공 상태인 경우 Alert표출 금지
            if isMissionSuccess { return }
            
            // Alert 표시
            let alertConfig: DSTwoButtonAlert.Config = .init(
                titleText: "나가면 운세를 받을 수 없어요",
                subTitleText: "미션을 수행하지 않고 나가시겠어요?",
                leftButtonText: "취소",
                rightButtonText: "나가기",
                leftButtonTapped: { [weak self] in
                    guard let self else { return }
                    router?.request(.dismissAlert())
                }, rightButtonTapped: { [weak self] in
                    guard let self else { return }
                    let completion = { [weak self] in
                        guard let self else { return }
                        listener?.request(request: .exitPage(isMissionCompleted: false))
                    }
                    router?.request(.dismissAlert(completion: completion))
                }
            )
            router?.request(.presentAlert(alertConfig))
            
        case .missionGuideFinished:
            let nextFlow: TapMissionFlow = .start
            self.currentMissionFlow = nextFlow
            presenter.request(.startMissionFlow(nextFlow))
        case .missionSuccessEventFinished:
            listener?.request(request: .exitPage(isMissionCompleted: true))
        }
    }
}
