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
    case detachCreateEditAlarm
    case routeToSnoozeOption(SnoozeOption)
    case detachSnoozeOption
    case routeToSoundOption(SoundOption)
    case detachSoundOption
}

public protocol RootRouting: Routing {
    func request(_ request: RootRouterRequest)
}

public protocol RootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
        // TODO: Pause any business logic.
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
            router?.request(.detachCreateEditAlarm)
        case let .snoozeOption(snoozeOption):
            router?.request(.routeToSnoozeOption(snoozeOption))
        case let .soundOption(soundOption):
            router?.request(.routeToSoundOption(soundOption))
        case let .done(alarm):
            router?.request(.detachCreateEditAlarm)
            service.scheduleTimer(with: alarm)
        }
    }
}

// MARK: CreateEditAlarmSnoozeOptionListenerRequest
extension RootInteractor {
    func request(_ request: CreateEditAlarmSnoozeOptionListenerRequest) {
        
        switch request {
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
        case let .done(soundOption):
            router?.request(.detachSoundOption)
            createAlarmMutableStream.mutableSoundOption.onNext(soundOption)
        }
    }
}
