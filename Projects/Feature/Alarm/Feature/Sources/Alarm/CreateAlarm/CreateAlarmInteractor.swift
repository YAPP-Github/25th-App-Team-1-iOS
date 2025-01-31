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
    case alarmUpdated(Alarm)
}

protocol CreateAlarmPresentable: Presentable {
    var listener: CreateAlarmPresentableListener? { get set }
    func request(_ request: CreateAlarmPresentableRequest)
}

enum CreateAlarmListenerRequest {
    case back
    case snoozeOption(SnoozeFrequency?, SnoozeCount?)
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
        mode: AlarmCreateEditMode,
        createAlarmStream: CreateAlarmStream
    ) {
        self.mode = mode
        self.createAlarmStream = createAlarmStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private let mode: AlarmCreateEditMode
    private let createAlarmStream: CreateAlarmStream
    private var alarm: Alarm = .default
    
    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }
    
    func request(_ request: CreateAlarmPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            start()
        case .back:
            listener?.request(.back)
        case let .meridiemChanged(meridiem):
            alarm.meridiem = meridiem
        case let .hourChanged(hour):
            alarm.hour = hour
        case let .minuteChanged(minute):
            alarm.minute = minute
        case let .selectedDaysChanged(set):
            alarm.repeatDays = set
        case .selectSnooze:
            listener?.request(.snoozeOption(alarm.snoozeFrequency, alarm.snoozeCount))
        case .selectSound:
            listener?.request(.soundOption)
        case .done:
            createAlarm()
        }
    }
    
    private func bind() {
        createAlarmStream.snoozeOptionChanged
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] options in
                guard let self else { return }
                alarm.snoozeFrequency = options.0
                alarm.snoozeCount = options.1
                presenter.request(.alarmUpdated(alarm))
            })
            .disposeOnDeactivate(interactor: self)
        
        createAlarmStream.soundOptionChanged
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] options in
                guard let self else { return }
                alarm.isVibrationOn = options.isVibrateOn
                alarm.isSoundOn = options.isSoundOn
                alarm.volume = options.volume
                alarm.selectedSound = options.selectedSound
                presenter.request(.alarmUpdated(alarm))
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func start() {
        switch mode {
        case .create:
            presenter.request(.alarmUpdated(alarm))
        case let .edit(alarm):
            self.alarm = alarm
            presenter.request(.alarmUpdated(alarm))
        }
    }
    
    private func createAlarm() {
        listener?.request(.done(alarm))
    }
}
