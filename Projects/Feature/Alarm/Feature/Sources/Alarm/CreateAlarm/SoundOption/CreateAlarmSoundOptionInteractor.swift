//
//  CreateAlarmSoundOptionInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/26/25.
//

import RIBs
import RxSwift

protocol CreateAlarmSoundOptionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CreateAlarmSoundOptionPresentable: Presentable {
    var listener: CreateAlarmSoundOptionPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol CreateAlarmSoundOptionListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class CreateAlarmSoundOptionInteractor: PresentableInteractor<CreateAlarmSoundOptionPresentable>, CreateAlarmSoundOptionInteractable, CreateAlarmSoundOptionPresentableListener {

    weak var router: CreateAlarmSoundOptionRouting?
    weak var listener: CreateAlarmSoundOptionListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: CreateAlarmSoundOptionPresentable) {
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
