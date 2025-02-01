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

enum CreateAlarmSnoozeOptionPresentableRequest {
    case disableOptions
    case enableOptions(SnoozeFrequency, SnoozeCount)
}

protocol CreateAlarmSnoozeOptionPresentable: Presentable {
    var listener: CreateAlarmSnoozeOptionPresentableListener? { get set }
    func request(_ request: CreateAlarmSnoozeOptionPresentableRequest)
}

enum CreateAlarmSnoozeOptionListenerRequest {
    case offSnooze
    case done(SnoozeFrequency, SnoozeCount)
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
        snoozeFrequency: SnoozeFrequency?,
        snoozeCount: SnoozeCount?
    ) {
        self.frequency = snoozeFrequency ?? .fiveMinutes
        self.count = snoozeCount ?? .fiveTimes
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private var isSnoozeOn: Bool = true
    private var frequency: SnoozeFrequency
    private var count: SnoozeCount
    
    func request(_ request: CreateAlarmSnoozeOptionPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.enableOptions(frequency, count))
        case let .isOnChanged(isOn):
            self.isSnoozeOn = isOn
            if isSnoozeOn {
                presenter.request(.enableOptions(frequency, count))
            } else {
                presenter.request(.disableOptions)
            }
        case let .frequencyChanged(frequency):
            self.frequency = frequency
            presenter.request(.enableOptions(frequency, count))
        case let .countChanged(count):
            self.count = count
            presenter.request(.enableOptions(frequency, count))
        case .done:
            guard isSnoozeOn else {
                listener?.request(.offSnooze)
                return
            }
            listener?.request(.done(frequency, count))
        }
    }
}
