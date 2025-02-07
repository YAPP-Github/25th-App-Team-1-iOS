//
//  CreateAlarmSnoozeOptionInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import RIBs
import RxSwift
import FeatureCommonDependencies

protocol CreateAlarmSnoozeOptionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum CreateAlarmSnoozeOptionPresentableRequest {
    case updateOption(SnoozeOption)
}

protocol CreateAlarmSnoozeOptionPresentable: Presentable {
    var listener: CreateAlarmSnoozeOptionPresentableListener? { get set }
    func request(_ request: CreateAlarmSnoozeOptionPresentableRequest)
}

enum CreateAlarmSnoozeOptionListenerRequest {
    case done(SnoozeOption)
}

protocol CreateAlarmSnoozeOptionListener: AnyObject {
    func request(_ request: CreateAlarmSnoozeOptionListenerRequest)
}

final class CreateAlarmSnoozeOptionInteractor: PresentableInteractor<CreateAlarmSnoozeOptionPresentable>, CreateAlarmSnoozeOptionInteractable, CreateAlarmSnoozeOptionPresentableListener {

    weak var router: CreateAlarmSnoozeOptionRouting?
    weak var listener: CreateAlarmSnoozeOptionListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CreateAlarmSnoozeOptionPresentable,
        snoozeOption: SnoozeOption
    ) {
        self.snoozeOption = snoozeOption
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private var snoozeOption: SnoozeOption
    
    func request(_ request: CreateAlarmSnoozeOptionPresentableListenerRequest) {
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
