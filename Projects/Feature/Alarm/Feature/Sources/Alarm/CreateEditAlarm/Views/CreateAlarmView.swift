//
//  CreateEditAlarmView.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import UIKit
import FeatureCommonDependencies
import FeatureUIDependencies
import FeatureThirdPartyDependencies

protocol CreateEditAlarmViewListener: AnyObject {
    func action(_ action: CreateEditAlarmView.Action)
}

final class CreateEditAlarmView: UIView {
    enum Action {
        case backButtonTapped
        case deleteButtonTapped
        case meridiemChanged(Meridiem)
        case hourChanged(Hour)
        case minuteChanged(Minute)
        case selectWeekday(AlarmDays)
        case snoozeButtonTapped
        case soundButtonTapped
        case doneButtonTapped
    }
    
    enum State {
        case showDeleteButton
        case titleUpdated(String)
        case alarmUpdated(Alarm)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: CreateEditAlarmViewListener?
    func update(state: State) {
        switch state {
        case .showDeleteButton:
            navigationBar.update(rightButtonTitle: "삭제".displayText(font: .body1Medium, color: R.Color.statusAlert))
        case let .titleUpdated(title):
            navigationBar.update(title: title)
        case let .alarmUpdated(alarm):
            updateView(with: alarm)
        }
    }
    
    private let alarmPickerContainer = UIView()
    private let alarmPicker = AlarmPicker()
    private let navigationBar = OnBoardingNavBarView()
    private let selectWeekDayView = SelectWeekDayView()
    private let doneButton = DSDefaultCTAButton()
    
    private func updateView(with alarm: Alarm) {
        layoutIfNeeded()
        selectWeekDayView.update(alarm: alarm)
        alarmPicker.update(
            meridiem: alarm.meridiem,
            hour: alarm.hour,
            minute: alarm.minute
        )
    }
    
    @objc
    private func doneButtonTapped() {
        listener?.action(.doneButtonTapped)
    }
}

private extension CreateEditAlarmView {
    func setupUI() {
        backgroundColor = R.Color.gray900
        navigationBar.do {
            $0.listener = self
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        alarmPicker.do {
            $0.listener = self
            $0.updateToNow()
        }
        selectWeekDayView.do {
            $0.listener = self
        }
        doneButton.do {
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.doneButtonTapped)
            }
            $0.update(title: "저장하기")
        }
        
        alarmPickerContainer.addSubview(alarmPicker)
        [navigationBar, alarmPickerContainer, selectWeekDayView, doneButton].forEach { addSubview($0) }
    }
    
    func layout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        selectWeekDayView.snp.makeConstraints {
            $0.bottom.equalTo(doneButton.snp.top).offset(-24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        alarmPickerContainer.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(selectWeekDayView.snp.top)
        }
        
        alarmPicker.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
    }
}


extension CreateEditAlarmView: OnBoardingNavBarViewListener {
    func action(_ action: OnBoardingNavBarView.Action) {
        switch action {
        case .backButtonClicked:
            listener?.action(.backButtonTapped)
        case .rightButtonClicked:
            listener?.action(.deleteButtonTapped)
        }
    }
}

extension CreateEditAlarmView: AlarmPickerListener {
    func latestSelection(meridiem: Meridiem, hour: Hour, minute: Minute) {
        listener?.action(.meridiemChanged(meridiem))
        listener?.action(.hourChanged(hour))
        listener?.action(.minuteChanged(minute))
    }
}

extension CreateEditAlarmView: SelectWeekDayViewListener {
    func action(_ action: SelectWeekDayView.Action) {
        switch action {
        case let .selectWeekday(set):
            listener?.action(.selectWeekday(set))
        case .snoozeButtonTapped:
            listener?.action(.snoozeButtonTapped)
        case .soundButtonTapped:
            listener?.action(.soundButtonTapped)
        }
    }
}
