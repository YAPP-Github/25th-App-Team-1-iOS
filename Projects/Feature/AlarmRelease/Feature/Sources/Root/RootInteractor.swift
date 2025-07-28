//
//  RootInteractor.swift
//  FeatureAlarmRelease
//
//  Created by ever on 7/1/25.
//

import RIBs
import UIKit
import RxSwift
import FeatureCommonEntity
import FeatureLogger
import FeatureAlarmCommon
import FeatureAlarmMission
import FeatureFortune
import FeatureNetworking
import FirebaseRemoteConfig

// TODO: 옮기기
enum FortuneError: Error {
    case userIdNotFound
}

extension Result {
    var value: Success? {
        guard case let .success(value) = self else {
            return nil
        }
        return value
    }

    var error: Failure? {
        guard case let .failure(error) = self else {
            return nil
        }
        return error
    }
}


public enum RootRouterRequest {
    case cleanUpViews
    case routeToIntro
    case routeToSnooze(SnoozeOption, Bool)
    case detachSnooze
    case routeToMission(missionType: AlarmMissionType)
    case detachAlarmMission
    case routeToFortune(Fortune, UserInfo, FortuneSaveInfo)
    case detachFortune
}

public protocol RootRouting: Routing {
    func request(_ request: RootRouterRequest)
}

public enum RootListenerRequest {
    case close
}

public protocol RootListener: AnyObject {
    func request(_ request: RootListenerRequest)
}

final class RootInteractor: Interactor, RootInteractable {

    weak var router: RootRouting?
    weak var listener: RootListener?

    private let fortunePublisher: PublishSubject<Result<Fortune, Error>> = .init()
    private let finishWithMissionComplete: PublishSubject<Bool> = .init()
    private let alarm: Alarm
    private let isFirstAlarm: Bool
    private let stream: ReleaseAlarmMutableStream
    private let logger: Logger
    init(
        alarm: Alarm,
        isFirstAlarm: Bool,
        stream: ReleaseAlarmMutableStream,
        logger: Logger
    ) {
        self.alarm = alarm
        self.isFirstAlarm = isFirstAlarm
        self.stream = stream
        self.logger = logger
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        bind()
        
        // 운세 API요청
        if let fortuneInfo = UserDefaults.standard.dailyFortune() {
            getFortune(fortuneId: fortuneInfo.id)
        } else {
            createFortune()
        }
        
        router?.request(.routeToIntro)
    }

    override func willResignActive() {
        super.willResignActive()
        router?.request(.cleanUpViews)
    }
    
    private func bind() {
        let fortuneFetchedSuccess = fortunePublisher.compactMap({ $0.value })
        
        Observable.combineLatest(finishWithMissionComplete, fortuneFetchedSuccess)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] completed, fortune in
                guard let self else { return }
                guard let fortuneInfo = UserDefaults.standard.dailyFortune() else {
                    listener?.request(.close)
                    return
                }
                var newFortuneInfo = fortuneInfo
                if fortuneInfo.shouldShowCharm == false {
                    newFortuneInfo.shouldShowCharm = isFirstAlarm && completed
                }
                UserDefaults.standard.setDailyFortune(info: newFortuneInfo)
                goToFortune(fortune: fortune, fortuneInfo: newFortuneInfo)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
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
        guard let userId = Preference.userId else {
            fortunePublisher.onNext(.failure(FortuneError.userIdNotFound))
            return
        }
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


// Intro
extension RootInteractor {
    func request(_ request: AlarmReleaseIntroListenerRequest) {
        switch request {
        case .releaseAlarm:
            let config = RemoteConfig.remoteConfig()
            let configValue = config["alarm_mission_type"].stringValue
            debugPrint("Remote config에서 획득한 미션타입: \(configValue)")
            let mission = AlarmMissionType(key: configValue)
            stream.stopTimerSubject.onNext(())
            router?.request(.routeToMission(
                missionType: mission
            ))
        case .snoozeAlarm:
            router?.request(.routeToSnooze(alarm.snoozeOption, alarm.mission != nil))
        }
    }
}

// Snooze
extension RootInteractor {
    func request(_ request: AlarmReleaseSnoozeListenerRequest) {
        router?.request(.detachSnooze)
        switch request {
        case .releaseAlarm:
            let config = RemoteConfig.remoteConfig()
            let configValue = config["alarm_mission_type"].stringValue
            debugPrint("Remote config에서 획득한 미션타입: \(configValue)")
            let mission = AlarmMissionType(key: configValue)
            router?.request(.routeToMission(missionType: mission))
        case .snoozeFinished:
            stream.snoozeFinishedSubject.onNext(())
        }
    }
}

// MARK: MissionMainListener
extension RootInteractor {
    func request(_ request: FeatureAlarmMission.AlarmMissionRootListenerRequest) {
        switch request {
        case .missionCompleted:
            router?.request(.detachAlarmMission)
            finishWithMissionComplete.onNext(true)
        case .close:
            router?.request(.detachAlarmMission)
            finishWithMissionComplete.onNext(false)
        }
    }
    
    private func goToFortune(fortune: Fortune, fortuneInfo: FortuneSaveInfo) {
        guard let userId = Preference.userId else { return }
        APIClient.request(
            UserInfoResponseDTO.self,
            request: APIRequest.Users.getUser(userId: userId),
            success: { [weak router] userInfo in
                guard let router else { return }
                let userInfoEntity = userInfo.toUserInfo()
                DispatchQueue.main.async {
                    router.request(.routeToFortune(fortune, userInfoEntity, fortuneInfo))
                }
            }) { error in
                // 유저정보 획득 실패
                debugPrint(error.localizedDescription)
            }
    }
}

// MARK: - FortuneListenerRequest
extension RootInteractor {
    func request(_ request: FeatureFortune.FortuneListenerRequest) {
        switch request {
        case .close:
            // 운세페이지를 닫을 경우 읽음 처리
//            UserDefaults.standard.setDailyFortuneChecked(isChecked: true)
            
            // 운세페이지 종료
            router?.request(.detachFortune)
            listener?.request(.close)
        }
    }
}
