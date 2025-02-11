//
//  AlarmReleaseSnoozeInteractor.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/12/25.
//

import RIBs
import RxSwift

protocol AlarmReleaseSnoozeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AlarmReleaseSnoozePresentable: Presentable {
    var listener: AlarmReleaseSnoozePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AlarmReleaseSnoozeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AlarmReleaseSnoozeInteractor: PresentableInteractor<AlarmReleaseSnoozePresentable>, AlarmReleaseSnoozeInteractable, AlarmReleaseSnoozePresentableListener {

    weak var router: AlarmReleaseSnoozeRouting?
    weak var listener: AlarmReleaseSnoozeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AlarmReleaseSnoozePresentable) {
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
