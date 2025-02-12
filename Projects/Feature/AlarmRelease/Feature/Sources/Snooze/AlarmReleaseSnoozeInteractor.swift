//
//  AlarmReleaseSnoozeInteractor.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/12/25.
//

import RIBs
import RxSwift
import FeatureCommonDependencies

protocol AlarmReleaseSnoozeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum AlarmReleaseSnoozePresentableRequest {
    case startTimer(SnoozeOption)
}

protocol AlarmReleaseSnoozePresentable: Presentable {
    var listener: AlarmReleaseSnoozePresentableListener? { get set }
    func request(_ request: AlarmReleaseSnoozePresentableRequest)
}

enum AlarmReleaseSnoozeListenerRequest {
    case releaseAlarm
    case snoozeFinished
}

protocol AlarmReleaseSnoozeListener: AnyObject {
    func request(_ request: AlarmReleaseSnoozeListenerRequest)
}

final class AlarmReleaseSnoozeInteractor: PresentableInteractor<AlarmReleaseSnoozePresentable>, AlarmReleaseSnoozeInteractable, AlarmReleaseSnoozePresentableListener {

    weak var router: AlarmReleaseSnoozeRouting?
    weak var listener: AlarmReleaseSnoozeListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: AlarmReleaseSnoozePresentable,
        snoozeOption: SnoozeOption
    ) {
        self.snoozeOption = snoozeOption
        super.init(presenter: presenter)
        presenter.listener = self
    }

    func request(_ request: AlarmReleaseSnoozePresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.startTimer(snoozeOption))
        case .releaseAlarm:
            listener?.request(.releaseAlarm)
        case .snoozeFinished:
            listener?.request(.snoozeFinished)
        }
    }
    
    private let snoozeOption: SnoozeOption
}
