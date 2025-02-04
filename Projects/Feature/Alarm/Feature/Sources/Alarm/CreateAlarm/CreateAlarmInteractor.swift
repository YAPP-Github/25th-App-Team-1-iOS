//
//  CreateAlarmInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import Foundation
import RIBs
import RxSwift
import FeatureResources
import FeatureCommonDependencies

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
    case snoozeOption(SnoozeOption)
    case soundOption(SoundOption)
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
        switch mode {
        case .create:
            let current = Calendar.current
            let now = Date()
            let hourValue = current.component(.hour, from: now)
            let minuteValue = current.component(.minute, from: now)
            let meridiem: Meridiem = hourValue < 12 ? .am : .pm
            let hour = Hour(hourValue % 12)!
            let minute = Minute(minuteValue)!
            let repeatDays = AlarmDays(days: [])
            let snoozeOption = SnoozeOption(isSnoozeOn: true, frequency: .fiveMinutes, count: .fiveTimes)
            let soundOption = SoundOption(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: "")
            self.alarm = .init(meridiem: meridiem, hour: hour, minute: minute, repeatDays: repeatDays, snoozeOption: snoozeOption, soundOption: soundOption)
        case .edit(let alarm):
            self.alarm = alarm
        }
        self.createAlarmStream = createAlarmStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private let mode: AlarmCreateEditMode
    private let createAlarmStream: CreateAlarmStream
    private var alarm: Alarm
    
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
            listener?.request(.snoozeOption(alarm.snoozeOption))
        case .selectSound:
            listener?.request(.soundOption(alarm.soundOption))
        case .done:
            createAlarm()
        }
    }
    
    private func bind() {
        createAlarmStream.snoozeOptionChanged
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] option in
                guard let self else { return }
                alarm.snoozeOption = option
                presenter.request(.alarmUpdated(alarm))
            })
            .disposeOnDeactivate(interactor: self)
        
        createAlarmStream.soundOptionChanged
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] option in
                guard let self else { return }
                alarm.soundOption = option
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
