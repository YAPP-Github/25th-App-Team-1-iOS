//
//  CreateEditAlarmSnoozeOptionInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs
import RxSwift
import FeatureCommonDependencies

protocol CreateEditAlarmSnoozeOptionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum CreateEditAlarmSnoozeOptionPresentableRequest {
    case updateOption(SnoozeOption)
}

protocol CreateEditAlarmSnoozeOptionPresentable: Presentable {
    var listener: CreateEditAlarmSnoozeOptionPresentableListener? { get set }
    func request(_ request: CreateEditAlarmSnoozeOptionPresentableRequest)
}

enum CreateEditAlarmSnoozeOptionListenerRequest {
    case done(SnoozeOption)
}

protocol CreateEditAlarmSnoozeOptionListener: AnyObject {
    func request(_ request: CreateEditAlarmSnoozeOptionListenerRequest)
}

final class CreateEditAlarmSnoozeOptionInteractor: PresentableInteractor<CreateEditAlarmSnoozeOptionPresentable>, CreateEditAlarmSnoozeOptionInteractable, CreateEditAlarmSnoozeOptionPresentableListener {

    weak var router: CreateEditAlarmSnoozeOptionRouting?
    weak var listener: CreateEditAlarmSnoozeOptionListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CreateEditAlarmSnoozeOptionPresentable,
        snoozeOption: SnoozeOption
    ) {
        self.snoozeOption = snoozeOption
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private var snoozeOption: SnoozeOption
    
    func request(_ request: CreateEditAlarmSnoozeOptionPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.updateOption(snoozeOption))
        case let .isOnChanged(isOn):
            snoozeOption.isSnoozeOn = isOn
            presenter.request(.updateOption(snoozeOption))
        case let .frequencyChanged(frequency):
            snoozeOption.frequency = frequency
            presenter.request(.updateOption(snoozeOption))
        case let .countChanged(count):
            snoozeOption.count = count
            presenter.request(.updateOption(snoozeOption))
        case .done:
            listener?.request(.done(snoozeOption))
        }
    }
}
