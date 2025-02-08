//
//  CreateEditAlarmInteractor.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import Foundation
import RIBs
import RxSwift
import FeatureUIDependencies
import FeatureCommonDependencies

enum CreateEditAlarmRouterRequest {
    case presentAlert(DSTwoButtonAlert.Config, DSTwoButtonAlertViewControllerListener)
    case dismissAlert(completion: (()->Void)? = nil)
}

protocol CreateEditAlarmRouting: ViewableRouting {
    func request(_ request: CreateEditAlarmRouterRequest)
}

enum CreateEditAlarmPresentableRequest {
    case showDeleteButton
    case updateTitle(String)
    case alarmUpdated(Alarm)
}

protocol CreateEditAlarmPresentable: Presentable {
    var listener: CreateEditAlarmPresentableListener? { get set }
    func request(_ request: CreateEditAlarmPresentableRequest)
}

enum CreateEditAlarmListenerRequest {
    case back
    case snoozeOption(SnoozeOption)
    case soundOption(SoundOption)
    case done(Alarm)
    case updated(Alarm)
    case deleted(Alarm)
}

protocol CreateEditAlarmListener: AnyObject {
    func request(_ request: CreateEditAlarmListenerRequest)
}

final class CreateEditAlarmInteractor: PresentableInteractor<CreateEditAlarmPresentable>, CreateEditAlarmInteractable, CreateEditAlarmPresentableListener {

    weak var router: CreateEditAlarmRouting?
    weak var listener: CreateEditAlarmListener?
    
    init(
        presenter: CreateEditAlarmPresentable,
        mode: AlarmCreateEditMode,
        createAlarmStream: CreateEditAlarmStream
    ) {
        self.mode = mode
        switch mode {
        case .create:
            let selectedSound = R.AlarmSound.allCases.sorted { $0.title < $1.title }.first?.title ?? ""
            self.alarm = .init(
                meridiem: .am,
                hour: Hour(6)!,
                minute: Minute(0)!,
                repeatDays: AlarmDays(days: []),
                snoozeOption: SnoozeOption(isSnoozeOn: true, frequency: .fiveMinutes, count: .fiveTimes),
                soundOption: SoundOption(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: selectedSound)
            )
        case .edit(let alarm):
            self.alarm = alarm
        }
        self.createAlarmStream = createAlarmStream
        super.init(presenter: presenter)
        presenter.listener = self
    }

    private let mode: AlarmCreateEditMode
    private let createAlarmStream: CreateEditAlarmStream
    private var alarm: Alarm
    
    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }
    
    func request(_ request: CreateEditAlarmPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            start()
        case .back:
            handleBack()
        case .delete:
            listener?.request(.deleted(alarm))
        case let .meridiemChanged(meridiem):
            alarm.meridiem = meridiem
            let title = alarm.timeRemainingDescription()
            presenter.request(.updateTitle(title))
        case let .hourChanged(hour):
            alarm.hour = hour
            let title = alarm.timeRemainingDescription()
            presenter.request(.updateTitle(title))
        case let .minuteChanged(minute):
            alarm.minute = minute
            let title = alarm.timeRemainingDescription()
            presenter.request(.updateTitle(title))
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
            presenter.request(.showDeleteButton)
            presenter.request(.alarmUpdated(alarm))
        }
    }
    
    private func handleBack() {
        switch mode {
        case .create:
            listener?.request(.back)
        case let .edit(alarm):
            if alarm.hashValue != self.alarm.hashValue {
                router?.request(.presentAlert(
                    DSTwoButtonAlert.Config(
                        titleText: "변경 사항 삭제",
                        subTitleText: """
                        변경 사항을 저장하지 않고
                        나가시겠어요?
                        """,
                        leftButtonText: "취소",
                        rightButtonText: "나가기"
                    ),
                    self
                ))
            } else {
                listener?.request(.back)
            }
        }
    }
    
    private func createAlarm() {
        switch mode {
        case .create:
            listener?.request(.done(alarm))
        case .edit:
            listener?.request(.updated(alarm))
        }
        
    }
}
extension CreateEditAlarmInteractor: DSTwoButtonAlertViewControllerListener {
    func action(_ action: DSTwoButtonAlertViewController.Action) {
        switch action {
        case .leftButtonClicked:
            router?.request(.dismissAlert(completion: nil))
        case .rightButtonClicked:
            router?.request(.dismissAlert(completion: { [weak listener] in
                listener?.request(.back)
            }))
        }
    }
}

extension Alarm {
    func timeRemainingDescription(from now: Date = Date()) -> String {
        let calendar = Calendar.current
        
        // nextDateComponents를 이용해 알람이 울릴 Date 생성
        guard let nextDate = calendar.date(from: self.nextDateComponents(from: now)) else {
            return "알 수 없음"
        }
        
        // 현재 시간과 알람 시간의 차이를 구함 (일, 시간, 분)
        let diffComponents = calendar.dateComponents([.day, .hour, .minute], from: now, to: nextDate)
        
        var parts: [String] = []
        
        // 하루 이상 걸린다면 일(day)만 표시
        if let day = diffComponents.day, day > 0 {
            parts.append("\(day)일")
        }
        
        // 시간(hour)은 항상 표시 (0시간인 경우는 생략할 수도 있음)
        if let hour = diffComponents.hour, hour > 0 {
            parts.append("\(hour)시간")
        }
        
        // 분(minute)도 필요하다면 추가 (예: 0일 0시간 30분 후)
        if let minute = diffComponents.minute, minute > 0 {
            parts.append("\(minute)분")
        }
        
        // 아무것도 남지 않은 경우 (즉, 바로 울릴 때) 처리
        if parts.isEmpty {
            return "곧 울려요"
        }
        
        return parts.joined(separator: " ") + " 후에 울려요"
    }
}
