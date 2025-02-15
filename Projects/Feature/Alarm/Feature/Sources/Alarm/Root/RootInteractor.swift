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

public enum RootRouterRequest {
    case cleanupViews
    case routeToCreateEditAlarm(mode: AlarmCreateEditMode)
    case routeToSnoozeOption(SnoozeOption)
    case detachSnoozeOption
    case routeToSoundOption(SoundOption)
    case detachSoundOption
}

public protocol RootRouting: Routing {
    func request(_ request: RootRouterRequest)
}

public enum RootListenerRequest {
    case close
    case done(Alarm)
    case updated(Alarm)
    case deleted(Alarm)
}

public protocol RootListener: AnyObject {
    func reqeust(_ request: RootListenerRequest)
}

final class RootInteractor: Interactor, RootInteractable {

    weak var router: RootRouting?
    weak var listener: RootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        service: RootServiceable,
        mode: AlarmCreateEditMode,
        alarmListMutableStream: AlarmListMutableStream,
        createAlarmMutableStream: CreateEditAlarmMutableStream
    ) {
        self.service = service
        self.mode = mode
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
    }
    
    private var service: RootServiceable
    private let mode: AlarmCreateEditMode
    private let alarmListMutableStream: AlarmListMutableStream
    private let createAlarmMutableStream: CreateEditAlarmMutableStream
    
    private func start() {
        router?.request(.routeToCreateEditAlarm(mode: mode))
    }
}

// MARK: CreateEditAlarmListenerRequest
extension RootInteractor {
    func request(_ request: CreateEditAlarmListenerRequest) {
        switch request {
        case .back:
            listener?.reqeust(.close)
        case let .snoozeOption(snoozeOption):
            router?.request(.routeToSnoozeOption(snoozeOption))
        case let .soundOption(soundOption):
            router?.request(.routeToSoundOption(soundOption))
        case let .done(alarm):
            listener?.reqeust(.done(alarm))
        case let .updated(alarm):
            listener?.reqeust(.updated(alarm))
        case let .deleted(alarm):
            listener?.reqeust(.deleted(alarm))
        }
    }
}

// MARK: CreateEditAlarmSnoozeOptionListenerRequest
extension RootInteractor {
    func request(_ request: CreateEditAlarmSnoozeOptionListenerRequest) {
        
        switch request {
        case .cancel:
            router?.request(.detachSnoozeOption)
        case let .done(snoozeOption):
            router?.request(.detachSnoozeOption)
            createAlarmMutableStream.mutableSnoozeOption.onNext(snoozeOption)
        }
    }
}

// MARK: CreateEditAlarmSoundOptionListenerRequest
extension RootInteractor {
    func request(_ request: CreateEditAlarmSoundOptionListenerRequest) {
        switch request {
        case .cancel:
            router?.request(.detachSoundOption)
        case let .done(soundOption):
            router?.request(.detachSoundOption)
            createAlarmMutableStream.mutableSoundOption.onNext(soundOption)
        }
    }
}
