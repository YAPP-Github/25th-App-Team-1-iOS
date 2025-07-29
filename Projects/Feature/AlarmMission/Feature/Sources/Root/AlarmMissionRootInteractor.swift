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
    case presentShakeMission(count: Int)
    case presentTapMission(count: Int)
    case dismissMission(Mission, competion: (() -> Void)? = nil)
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
    private let mission: Mission
    internal let isPreviewMode: Bool
    
    // Stream
    private let missionAction: PublishRelay<MissionState>
    private let disposeBag = DisposeBag()
    
    init(mission: Mission, missionAction: PublishRelay<MissionState>, isPreviewMode: Bool = false) {
        self.mission = mission
        self.missionAction = missionAction
        self.isPreviewMode = isPreviewMode
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        // 미션이벤트 옵저빙
        handleMissionAction()

        // 미션시작
        switch mission.type {
        case .shake:
            router?.request(.presentShakeMission(count: mission.count))
        case .tap:
            router?.request(.presentTapMission(count: mission.count))
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
                router?.request(.dismissMission(mission))
                listener?.request(.close)
            })
            .disposed(by: disposeBag)
        
        finishWithMissionComplete
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                router?.request(.dismissMission(mission))
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
