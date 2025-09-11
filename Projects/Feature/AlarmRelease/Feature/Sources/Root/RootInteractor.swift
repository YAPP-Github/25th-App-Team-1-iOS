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
    case routeToMission(mission: Mission)
    case detachAlarmMission
    case routeToFortune(Fortune, UserInfo, FortuneSaveInfo)
    case detachFortune
    case detachIntro
    case showLoading
    case hideLoading
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
    private let userInfoPublisher: PublishSubject<Result<UserInfo, Error>> = .init()
    private let finishWithMissionComplete: PublishSubject<Bool> = .init()
    private let alarm: Alarm
    private let isFirstAlarm: Bool
    private let stream: ReleaseAlarmMutableStream
    private let logger: Logger
    
    // API 완료 상태 추적
    private var isFortuneReady = false
    private var isUserInfoReady = false
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
        
        // API 미리 로드 시작
        preloadAPIs()
        
        router?.request(.routeToIntro)
    }

    override func willResignActive() {
        super.willResignActive()
        router?.request(.cleanUpViews)
    }
    
    private func bind() {
        let fortuneFetchedSuccess = fortunePublisher.compactMap({ $0.value })
        let userInfoFetchedSuccess = userInfoPublisher.compactMap({ $0.value })
        
        // API 완료 상태 추적
        fortuneFetchedSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                isFortuneReady = true
            })
            .disposeOnDeactivate(interactor: self)
            
        userInfoFetchedSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                isUserInfoReady = true
            })
            .disposeOnDeactivate(interactor: self)
        
        // 미션 완료 시 로딩 관리
        finishWithMissionComplete
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] completed in
                guard let self else { return }
                
                if isFortuneReady && isUserInfoReady {
                    // 이미 모든 API가 완료된 경우 바로 운세 화면으로
                    // (combineLatest에서 처리됨)
                } else {
                    // API가 아직 완료되지 않은 경우 로딩 표시
                    router?.request(.showLoading)
                }
            })
            .disposeOnDeactivate(interactor: self)
        
        Observable.combineLatest(finishWithMissionComplete, fortuneFetchedSuccess, userInfoFetchedSuccess)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] completed, fortune, userInfo in
                guard let self else { return }
                guard let fortuneInfo = UserDefaults.standard.dailyFortune() else {
                    router?.request(.hideLoading)
                    router?.request(.detachIntro)
                    listener?.request(.close)
                    return
                }
                var newFortuneInfo = fortuneInfo
                if fortuneInfo.shouldShowCharm == false {
                    newFortuneInfo.shouldShowCharm = isFirstAlarm && completed
                }
                UserDefaults.standard.setDailyFortune(info: newFortuneInfo)
                
                // 로딩 숨기고 운세 화면으로 이동
                router?.request(.hideLoading)
                router?.request(.routeToFortune(fortune, userInfo, newFortuneInfo))
            })
            .disposeOnDeactivate(interactor: self)
            
        // API 에러 처리
        Observable.merge(
            fortunePublisher.compactMap { result -> Error? in
                if case .failure(let error) = result { return error }
                return nil
            },
            userInfoPublisher.compactMap { result -> Error? in
                if case .failure(let error) = result { return error }
                return nil
            }
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] error in
            guard let self else { return }
            router?.request(.hideLoading)
            debugPrint("API Error: \(error.localizedDescription)")
            // 에러 발생 시 앱 종료
            router?.request(.detachIntro)
            listener?.request(.close)
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
            let info = FortuneSaveInfo(
                id: fortune.id,
                shouldShowCharm: false,
                charmIndex: nil
            )
            UserDefaults.standard.setDailyFortune(info: info)
            fortunePublisher.onNext(.success(fortune))
        } failure: { [weak self] error in
            guard let self else { return }
            fortunePublisher.onNext(.failure(error))
        }
    }
    
    private func preloadAPIs() {
        // 운세 API 호출
        if let fortuneInfo = UserDefaults.standard.dailyFortune() {
            getFortune(fortuneId: fortuneInfo.id)
        } else {
            createFortune()
        }
        
        // UserInfo API 호출
        preloadUserInfo()
    }
    
    private func preloadUserInfo() {
        guard let userId = Preference.userId else {
            userInfoPublisher.onNext(.failure(FortuneError.userIdNotFound))
            return
        }
        
        let request = APIRequest.Users.getUser(userId: userId)
        APIClient.request(UserInfoResponseDTO.self, request: request) { [weak self] userInfoDTO in
            guard let self else { return }
            let userInfo = userInfoDTO.toUserInfo()
            userInfoPublisher.onNext(.success(userInfo))
        } failure: { [weak self] error in
            guard let self else { return }
            userInfoPublisher.onNext(.failure(error))
        }
    }
}


// Intro
extension RootInteractor {
    func request(_ request: AlarmReleaseIntroListenerRequest) {
        switch request {
        case .releaseAlarm:
            stream.stopTimerSubject.onNext(())
            if let mission = alarm.mission {
                router?.request(.routeToMission(mission: mission))
            } else {
                finishWithMissionComplete.onNext(true)
            }
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
            if let mission = alarm.mission {
                router?.request(.routeToMission(mission: mission))
            } else {
                finishWithMissionComplete.onNext(true)
            }
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
            router?.request(.detachIntro)
            listener?.request(.close)
        }
    }
}
