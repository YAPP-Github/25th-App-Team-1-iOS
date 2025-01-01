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
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        start()
    }

    override func willResignActive() {
        super.willResignActive()

        router?.request(.cleanupViews)
        // TODO: Pause any business logic.
    }
    
    private func start() {
        router?.request(.routeToAlarmList)
    }
}

extension RootInteractor {
    func request(_ request: AlarmListListenerRequest) {
        switch request {
        case .addAlarm:
            router?.request(.routeToCreateAlarm)
        }
    }
}
