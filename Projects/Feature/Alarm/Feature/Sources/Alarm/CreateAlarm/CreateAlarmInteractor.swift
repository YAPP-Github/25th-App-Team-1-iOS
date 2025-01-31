//
//  CreateAlarmInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import RIBs
import RxSwift

protocol CreateAlarmRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum CreateAlarmPresentableRequest {
    case initialState(Alarm)
}

protocol CreateAlarmPresentable: Presentable {
    var listener: CreateAlarmPresentableListener? { get set }
    func request(_ request: CreateAlarmPresentableRequest)
}

enum CreateAlarmListenerRequest {
    case snoozeOption
    case soundOption
    case done(Alarm)
}

protocol CreateAlarmListener: AnyObject {
    func request(_ request: CreateAlarmListenerRequest)
}

final class CreateAlarmInteractor: PresentableInteractor<CreateAlarmPresentable>, CreateAlarmInteractable, CreateAlarmPresentableListener {

    weak var router: CreateAlarmRouting?
    weak var listener: CreateAlarmListener?
    
    init(
        presenter: CreateAlarmPresentable,
        mode: AlarmCreateEditMode
    ) {
        self.mode = mode
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private let mode: AlarmCreateEditMode
    private var alarm: Alarm = .default
    
    func request(_ request: CreateAlarmPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            start()
        case let .meridiemChanged(meridiem):
            alarm.meridiem = meridiem
        case let .hourChanged(hour):
            alarm.hour = hour
        case let .minuteChanged(minute):
            alarm.minute = minute
        case let .selectedDaysChanged(set):
            print(set)
        case .selectSnooze:
            listener?.request(.snoozeOption)
        case .selectSound:
            listener?.request(.soundOption)
        case .done:
            createAlarm()
        }
    }
    
    private func start() {
        switch mode {
        case .create:
            presenter.request(.initialState(alarm))
        case let .edit(alarm):
            self.alarm = alarm
            presenter.request(.initialState(alarm))
        }
    }
    
    private func createAlarm() {
        listener?.request(.done(alarm))
    }
}
