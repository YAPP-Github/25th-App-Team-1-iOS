//
//  CreateAlarmSnoozeOptionInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs
import RxSwift

protocol CreateAlarmSnoozeOptionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CreateAlarmSnoozeOptionPresentable: Presentable {
    var listener: CreateAlarmSnoozeOptionPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CreateAlarmSnoozeOptionListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CreateAlarmSnoozeOptionInteractor: PresentableInteractor<CreateAlarmSnoozeOptionPresentable>, CreateAlarmSnoozeOptionInteractable, CreateAlarmSnoozeOptionPresentableListener {

    weak var router: CreateAlarmSnoozeOptionRouting?
    weak var listener: CreateAlarmSnoozeOptionListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CreateAlarmSnoozeOptionPresentable) {
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
