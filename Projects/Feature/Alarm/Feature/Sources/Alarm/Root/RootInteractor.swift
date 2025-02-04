//
//  RootInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import RIBs
import RxSwift
import FeatureResources
import FeatureCommonDependencies

enum RootRouterRequest {
    case cleanupViews
    case routeToAlarmList
    case routeToCreateAlarm(mode: AlarmCreateEditMode)
    case detachCreateAlarm
    case routeToSnoozeOption(SnoozeOption)
    case detachSnoozeOption
    case routeToSoundOption(SoundOption)
    case detachSoundOption
}

protocol RootRouting: Routing {
    func request(_ request: RootRouterRequest)
}

protocol RootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: Interactor, RootInteractable {

    weak var router: RootRouting?
    weak var listener: RootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        service: RootServiceable,
        alarmListMutableStream: AlarmListMutableStream,
        createAlarmMutableStream: CreateAlarmMutableStream
    ) {
        self.service = service
        self.alarmListMutableStream = alarmListMutableStream
        self.createAlarmMutableStream = createAlarmMutableStream
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        start()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.request(.cleanupViews)
        // TODO: Pause any business logic.
    }
    
    private var service: RootServiceable
    private let alarmListMutableStream: AlarmListMutableStream
    private let createAlarmMutableStream: CreateAlarmMutableStream
    
    private func start() {
        router?.request(.routeToAlarmList)
    }
}

// MARK: AlarmListListenerRequest
extension RootInteractor {
    func request(_ request: AlarmListListenerRequest) {
        switch request {
        case .addAlarm:
            router?.request(.routeToCreateAlarm(mode: .create))
        }
    }
}

// MARK: CreateAlarmListenerRequest
extension RootInteractor {
    func request(_ request: CreateAlarmListenerRequest) {
        switch request {
        case .back:
            router?.request(.detachCreateAlarm)
        case let .snoozeOption(snoozeOption):
            router?.request(.routeToSnoozeOption(snoozeOption))
        case let .soundOption(soundOption):
            router?.request(.routeToSoundOption(soundOption))
        case let .done(alarm):
            router?.request(.detachCreateAlarm)
            service.scheduleTimer(with: alarm)
        }
    }
}

// MARK: CreateAlarmSnoozeOptionListenerRequest
extension RootInteractor {
    func request(_ request: CreateAlarmSnoozeOptionListenerRequest) {
        
        switch request {
        case let .done(snoozeOption):
            router?.request(.detachSnoozeOption)
            createAlarmMutableStream.mutableSnoozeOption.onNext(snoozeOption)
        }
    }
}

// MARK: CreateAlarmSoundOptionListenerRequest
extension RootInteractor {
    func request(_ request: CreateAlarmSoundOptionListenerRequest) {
        switch request {
        case let .done(soundOption):
            router?.request(.detachSoundOption)
            createAlarmMutableStream.mutableSoundOption.onNext(soundOption)
        }
    }
}
