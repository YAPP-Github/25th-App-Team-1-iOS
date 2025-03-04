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

public protocol MissionRootRouting: Routing {
    func cleanupViews()
    func request(_ request: MissionRootRoutingRequest)
}

public enum MissionRootRoutingRequest {
    case presentShakeMission(isFirstAlarm: Bool)
    case presentTapMission
    case dismissMission(Mission)
    case presentAlert(DSButtonAlert.Config)
}

public enum MissionRootListenerRequest {
    case missionCompleted(Fortune, FortuneSaveInfo)
    case close(Fortune?, FortuneSaveInfo?)
}

public protocol MissionRootListener: AnyObject {
    func request(_ request: MissionRootListenerRequest)
}

final class MissionRootInteractor: Interactor, MissionRootInteractable {

    weak var router: MissionRootRouting?
    weak var listener: MissionRootListener?
    
    
    // Fortune
    private let isFirstAlarm: Bool
    private let fortunePublisher: PublishSubject<Result<Fortune, Error>> = .init()
    
    
    // Stream
    private let missionAction: PublishRelay<MissionState>
    private let disposeBag = DisposeBag()
    
    
    //
    private let mission: Mission
    
    init(mission: Mission, isFirstAlarm: Bool, missionAction: PublishRelay<MissionState>) {
        self.mission = mission
        self.isFirstAlarm = isFirstAlarm
        self.missionAction = missionAction
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        if let fortuneInfo = UserDefaults.standard.dailyFortune() {
            getFortune(fortuneId: fortuneInfo.id)
        } else {
            createFortune()
        }
        
        // 미션이벤트 옵저빙
        handleMissionAction()
        
        // 미션시작
        switch mission {
        case .shake:
            router?.request(.presentShakeMission(isFirstAlarm: isFirstAlarm))
        case .tap:
            router?.request(.presentTapMission)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
}


// MARK: Fortune
extension MissionRootInteractor {
    private func getFortune(fortuneId: Int) {
        let request = APIRequest.Fortune.getFortune(fortuneId: fortuneId)
        APIClient.request(Fortune.self, request: request) { [weak self] fortune in
            guard let self else { return }
            fortunePublisher.onNext(.success(fortune))
        } failure: { [weak self] error in
            guard let self else { return }
            fortunePublisher.onNext(.failure(error))
        }
    }
    
    private func createFortune() {
        guard let userId = Preference.userId else { return }
        let request = APIRequest.Fortune.createFortune(userId: userId)
        APIClient.request(Fortune.self, request: request) { [weak self] fortune in
            guard let self else { return }
            fortunePublisher.onNext(.success(fortune))
            let info = FortuneSaveInfo(
                id: fortune.id,
                shouldShowCharm: false,
                charmIndex: nil
            )
            UserDefaults.standard.setDailyFortune(info: info)
        } failure: { [weak self] error in
            guard let self else { return }
            fortunePublisher.onNext(.failure(error))
        }
    }
}


// MARK: Mission action
private extension MissionRootInteractor {
    func handleMissionAction() {
        let finishWithMissionComplete = missionAction.filter {$0 == .missionIsCompleted}
        missionAction.filter {$0 == .exitMission}
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                router?.request(.dismissMission(mission))
                listener?.request(.close(nil, nil))
            })
            .disposed(by: disposeBag)
        
        let fortuneFetchedSuccess = fortunePublisher.compactMap({ $0.value })
        
        finishWithMissionComplete
            .withLatestFrom(fortuneFetchedSuccess)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] fortune in
                guard let self else { return }
                guard let fortuneInfo = UserDefaults.standard.dailyFortune() else {
                    listener?.request(.close(nil, nil))
                    return
                }
                var newFortuneInfo = fortuneInfo
                if fortuneInfo.shouldShowCharm == false {
                    newFortuneInfo.shouldShowCharm = isFirstAlarm
                }
                UserDefaults.standard.setDailyFortune(info: newFortuneInfo)
                
                router?.request(.dismissMission(mission))
                listener?.request(.missionCompleted(
                    fortune, newFortuneInfo
                ))
            })
            .disposed(by: disposeBag)
        
        
        fortunePublisher.compactMap({ $0.error })
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self else { return }
                // 운세 획득 실패
                let config = DSButtonAlert.Config(
                    titleText: "운세 획득 실패",
                    subTitleText: "운세를 가져오는 과정에서\n문제가 발생했어요!",
                    buttonText: "닫기",
                    buttonAction: { [weak self] in
                        guard let self else { return }
                        listener?.request(.close(nil, nil))
                    }
                )
                router?.request(.presentAlert(config))
            })
            .disposed(by: disposeBag)
    }
}
