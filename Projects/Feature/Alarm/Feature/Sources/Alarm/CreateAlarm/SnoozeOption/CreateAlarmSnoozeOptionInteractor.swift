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
    case cancel
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
    
    private var isSnoozeOn: Bool = true
    private var frequency: SnoozeFrequency = .fiveMinutes
    private var count: SnoozeCount = .fiveTimes
    
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
        case let .countChanged(count):
            self.count = count
        case .done:
            listener?.request(.done(frequency, count))
        }
    }
}
