//
//  MissionRootInteractor.swift
//  FeatureAlarmMission
//
//  Created by choijunios on 3/4/25.
//

import Foundation

import FeatureCommonDependencies
import FeatureNetworking
import FeatureDesignSystem

import RIBs
import RxSwift
import RxRelay

public protocol AlarmMissionRootRouting: Routing {
    func cleanupViews()
    func request(_ request: AlarmMissionRootRoutingRequest)
}

public enum AlarmMissionRootRoutingRequest {
    case presentShakeMission
    case presentTapMission
    case dismissMission(AlarmMissionType, competion: (() -> Void)? = nil)
    case dismissAlert(competion: (() -> Void)? = nil)
    case presentAlert(DSButtonAlert.Config)
}

public enum AlarmMissionRootListenerRequest {
    case missionCompleted
    case close
}

public protocol AlarmMissionRootListener: AnyObject {
    func request(_ request: AlarmMissionRootListenerRequest)
}

final class AlarmMissionRootInteractor: Interactor, AlarmMissionRootInteractable {

    weak var router: AlarmMissionRootRouting?
    weak var listener: AlarmMissionRootListener?
    
    // State
    private let missionType: AlarmMissionType
    
    // Stream
    private let missionAction: PublishRelay<MissionState>
    private let disposeBag = DisposeBag()
    
    
    init(missionType: AlarmMissionType, missionAction: PublishRelay<MissionState>) {
        self.missionType = missionType
        self.missionAction = missionAction
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        // 미션이벤트 옵저빙
        handleMissionAction()

        // 미션시작
        switch missionType {
        case .shake:
            router?.request(.presentShakeMission)
        case .tap:
            router?.request(.presentTapMission)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
}

// MARK: Mission action
private extension AlarmMissionRootInteractor {
    func handleMissionAction() {
        let finishWithMissionComplete = missionAction.filter {$0 == .missionIsCompleted}
        missionAction.filter {$0 == .exitMission}
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                router?.request(.dismissMission(missionType))
                listener?.request(.close)
            })
            .disposed(by: disposeBag)
        
        finishWithMissionComplete
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                router?.request(.dismissMission(missionType))
                listener?.request(.missionCompleted)
            })
            .disposed(by: disposeBag)
    }
}

extension AlarmMissionRootInteractor {
    func request(request: ShakeMissionWorkingListenerRequest) {
        switch request {
        case let .exitPage(isMissionCompleted):
            if isMissionCompleted {
                missionAction.accept(.missionIsCompleted)
            } else {
                missionAction.accept(.exitMission)
            }
            
        }
    }
    func request(request: TapMissionWorkingListenerRequest) {
        switch request {
        case let .exitPage(isMissionCompleted):
            if isMissionCompleted {
                missionAction.accept(.missionIsCompleted)
            } else {
                missionAction.accept(.exitMission)
            }
        }
    }
}
