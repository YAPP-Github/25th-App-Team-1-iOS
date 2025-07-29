//
//  RootInteractor.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/22/25.
//

import RIBs
import RxSwift

import FeatureConfigureMissionForAlarm

protocol RootRouting: ViewableRouting {
    func request(_ request: RootRoutingRequest)
}

enum RootRoutingRequest {
    case presentConfigureMissionForAlarm
    case dismissConfigureMissionForAlarm
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    
    
}

protocol RootListener: AnyObject { }

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}


extension RootInteractor {
    func request(_ request: RootPresentableListenerRequest) {
        switch request {
        case .startButtonTapped:
            router?.request(.presentConfigureMissionForAlarm)
        }
    }
}


extension RootInteractor {
    func request(_ request: ConfigureMissionForAlarmListenerRequest) {
        switch request {
        case .dismissScreen:
            router?.request(.dismissConfigureMissionForAlarm)
        case .missionSelected(let mission):
            router?.request(.dismissConfigureMissionForAlarm)
        }
    }
}
