//
//  CreateAlarmView.swift
//  FeatureAlarm
//
//  Created by ever on 12/30/24.
//

import UIKit
import SnapKit
import Then
import FeatureDesignSystem
import FeatureResources

protocol CreateAlarmViewListener: AnyObject {
    func action(_ action: CreateAlarmView.Action)
}

final class CreateAlarmView: UIView {
    enum Action {
        case backButtonTapped
        case meridiemChanged(MeridiemItem)
        case hourChanged(Int)
        case minuteChanged(Int)
        case selectWeekday(Set<DayOfWeek>)
        case snoozeButtonTapped
        case soundButtonTapped
        case doneButtonTapped
    }
    
    enum State {
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
    
    // MARK: - Internal
    weak var listener: CreateAlarmViewListener?
    
    func update(state: State) {
        switch state {
        case let .alarmUpdated(alarm):
            updateView(with: alarm)
        }
    }
    
    private let alarmPicker: AlarmPicker = .init(
        meridiemColumns: MeridiemItem.allCases.map { item in
            return PickerSelectionItem(
                content: item.content,
                displayingText: item.displayingText
            )
        },
        hourColumns: (1...12).map { hour in
            return PickerSelectionItem(
                content: String(hour),
                displayingText: "\(hour)"
            )
        },
        minuteColumns: (0...60).map { minute in
            var displayingText = "\(minute)"
            if minute < 10 {
                displayingText = "0\(minute)"
            }
            
            return PickerSelectionItem(
                content: String(minute),
                displayingText: displayingText
            )
        }
    )
    private let navigationBar = OnBoardingNavBarView()
    private let selectWeekDayView = SelectWeekDayView()
    private let doneButton = DSDefaultCTAButton()
    
    private func updateView(with alarm: Alarm) {
        alarmPicker.update(
            meridiem: alarm.meridiem,
            hour: alarm.hour,
            minute: alarm.minute
        )
        selectWeekDayView.update(alarm: alarm)
    }
    
    @objc
    private func doneButtonTapped() {
        listener?.action(.doneButtonTapped)
    }
}

private extension CreateAlarmView {
    func setupUI() {
        backgroundColor = R.Color.gray900
        navigationBar.do {
            $0.listener = self
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
        
        
        [navigationBar, alarmPicker, selectWeekDayView, doneButton].forEach { addSubview($0) }
    }
    
    func layout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        alarmPicker.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(42)
            $0.horizontalEdges.equalToSuperview()
                .inset(20)
        }
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        selectWeekDayView.snp.makeConstraints {
            $0.top.equalTo(alarmPicker.snp.bottom).offset(50)
            $0.bottom.equalTo(doneButton.snp.top).offset(-24)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

extension CreateAlarmView: OnBoardingNavBarViewListener {
    func action(_ action: OnBoardingNavBarView.Action) {
        switch action {
        case .backButtonClicked:
            listener?.action(.backButtonTapped)
        }
    }
}

extension CreateAlarmView: AlarmPickerListener {
    func latestSelection(meridiem: String, hour: Int, minute: Int) {
        if meridiem == "AM" {
            listener?.action(.meridiemChanged(.ante))
        } else {
            listener?.action(.meridiemChanged(.post))
        }
        
        listener?.action(.hourChanged(hour))
        listener?.action(.minuteChanged(minute))
    }
}

extension CreateAlarmView: SelectWeekDayViewListener {
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
