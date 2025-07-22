//
//  ConfigureMissionForAlarmInteractor.swift
//  FeatureConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import RIBs
import RxSwift

public protocol ConfigureMissionForAlarmRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ConfigureMissionForAlarmPresentable: Presentable {
    var listener: ConfigureMissionForAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol ConfigureMissionForAlarmListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ConfigureMissionForAlarmInteractor: PresentableInteractor<ConfigureMissionForAlarmPresentable>, ConfigureMissionForAlarmInteractable, ConfigureMissionForAlarmPresentableListener {

    weak var router: ConfigureMissionForAlarmRouting?
    weak var listener: ConfigureMissionForAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ConfigureMissionForAlarmPresentable) {
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


extension ConfigureMissionForAlarmInteractor {
    func request(_ request: ConfigureMissionForAlarmPresenterRequest) {
        
    }
}
