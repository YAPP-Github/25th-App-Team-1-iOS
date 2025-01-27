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
    case routeToCreateAlarm
    case detachCreateAlarm
    case routeToSnoozeOption
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
        stream: AlarmListMutableStream
    ) {
        self.service = service
        self.stream = stream
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
    private let stream: AlarmListMutableStream
    
    private func start() {
        router?.request(.routeToAlarmList)
    }
}

// MARK: AlarmListListenerRequest
extension RootInteractor {
    func request(_ request: AlarmListListenerRequest) {
        switch request {
        case .addAlarm:
            router?.request(.routeToCreateAlarm)
        }
    }
}

// MARK: CreateAlarmListenerRequest
extension RootInteractor {
    func request(_ request: CreateAlarmListenerRequest) {
        switch request {
        case .snoozeOption:
            router?.request(.routeToSnoozeOption)
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
        case .cancel:
            router?.request(.detachSnoozeOption)
        case let .done(frequency, count):
            router?.request(.detachSnoozeOption)
            print("frequency: \(frequency.rawValue), count: \(count.rawValue)")
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
