//
//  RootInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import RIBs
import RxSwift

enum RootRouterRequest {
    case cleanupViews
    case routeToAlarmList
    case routeToCreateAlarm(mode: AlarmCreateEditMode)
    case detachCreateAlarm
    case routeToSnoozeOption(SnoozeFrequency?, SnoozeCount?)
    case detachSnoozeOption
    case routeToSoundOption
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
    
    private let service: RootServiceable
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
        case let .snoozeOption(snoozeOption, snoozeCount):
            router?.request(.routeToSnoozeOption(snoozeOption, snoozeCount))
        case .soundOption:
            router?.request(.routeToSoundOption)
        case let .done(alarm):
            router?.request(.detachCreateAlarm)
            service.createAlarm(alarm)
        }
    }
}

// MARK: CreateAlarmSnoozeOptionListenerRequest
extension RootInteractor {
    func request(_ request: CreateAlarmSnoozeOptionListenerRequest) {
        
        switch request {
        case .offSnooze:
            router?.request(.detachSnoozeOption)
            createAlarmMutableStream.mutableSnoozeOption.onNext((nil, nil))
        case let .done(frequency, count):
            router?.request(.detachSnoozeOption)
            createAlarmMutableStream.mutableSnoozeOption.onNext((frequency, count))
        }
    }
}

// MARK: CreateAlarmSoundOptionListenerRequest
extension RootInteractor {
    func request(_ request: CreateAlarmSoundOptionListenerRequest) {
        switch request {
        case .done:
            router?.request(.detachSoundOption)
        }
    }
}
