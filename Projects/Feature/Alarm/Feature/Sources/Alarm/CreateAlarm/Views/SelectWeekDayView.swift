//
//  SelectWeekDayView.swift
//  FeatureAlarm
//
//  Created by ever on 1/16/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources

protocol SelectWeekDayViewListener: AnyObject {
    func action(_ action: SelectWeekDayView.Action)
}

final class SelectWeekDayView: UIView {
    enum Action {
        case selectWeekday(Set<DayOfWeek>)
        case snoozeButtonTapped
        case soundButtonTapped
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
    weak var listener: SelectWeekDayViewListener?
    func update(alarm: Alarm) {
        self.selectedDays = alarm.repeatDays
        updateButtons()
        
        if let snoozeFrequency = alarm.snoozeFrequency,
           let snoozeCount = alarm.snoozeCount {
            snoozeValueButton.setAttributedTitle("\(snoozeFrequency.rawValue), \(snoozeCount.rawValue)".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        } else {
            snoozeValueButton.setAttributedTitle("안 함".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        }
        
        if alarm.isSoundOn {
            var soundTitle = alarm.isVibrationOn ? "진동, " : ""
            soundTitle.append(alarm.selectedSound?.title ?? "")
            soundValueButton.setAttributedTitle(soundTitle.displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        } else {
            soundValueButton.setAttributedTitle("안 함".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        }
    }
    
    // MARK: - Properties
    private var selectedDays = Set<DayOfWeek>()
    private var isWeekendDisabled = false
    
    // MARK: - Views
    private let weekdayRepeatLabel = UILabel()
    private let weekdayToggleButton = UIButton(type: .system)
    private let weekendToggleButton = UIButton(type: .system)
    
    private let sundayButton = DateItemButton()
    private let mondayButton = DateItemButton()
    private let tuesdayButton = DateItemButton()
    private let wednesdayButton = DateItemButton()
    private let thursdayButton = DateItemButton()
    private let fridayButton = DateItemButton()
    private let saturdayButton = DateItemButton()
    
    private var weekdayButtons: [DateItemButton] {
        [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton]
    }
    
    private var weekendButtons: [DateItemButton] {
        [saturdayButton, sundayButton]
    }
    
    private let dayButtonsStackView = UIStackView()
    
    private let holidayImageView = UIImageView()
    private let holidayLabel = UILabel()
    private let holidayToggle = UISwitch()
    
    private let snoozeDivider = UIView()
    private let snoozeTitleLabel = UILabel()
    private let snoozeValueButton = UIButton()
    
    private let soundDivider = UIView()
    private let soundTitleLabel = UILabel()
    private let soundValueButton = UIButton()
    
    @objc
    private func holidayToggleChanged(toggle: UISwitch) {
        toggle.thumbTintColor = toggle.isOn ? R.Color.gray800 : R.Color.gray300
        isWeekendDisabled = toggle.isOn
        updateButtons()
        listener?.action(.selectWeekday(selectedDays))
    }
    
    @objc
    private func dayButtonTapped(button: UIButton) {
        switch button {
        case sundayButton:
            toggleDay(day: .sunday)
        case mondayButton:
            toggleDay(day: .monday)
        case tuesdayButton:
            toggleDay(day: .tuesday)
        case wednesdayButton:
            toggleDay(day: .wednesday)
        case thursdayButton:
            toggleDay(day: .thursday)
        case fridayButton:
            toggleDay(day: .friday)
        case saturdayButton:
            toggleDay(day: .saturday)
        default:
            break
        }
        listener?.action(.selectWeekday(selectedDays))
    }
    
    @objc
    private func weekdayToggleButtonTapped() {
        let isWeekdaySelected = DayOfWeek.weekdays.isSubset(of: selectedDays)
        if isWeekdaySelected {
            selectedDays.subtract(DayOfWeek.weekdays)
        } else {
            selectedDays.formUnion(DayOfWeek.weekdays)
        }
        updateButtons()
        listener?.action(.selectWeekday(selectedDays))
    }
    
    @objc
    private func weekendToggleButtonTapped() {
        let isWeekendSelected = DayOfWeek.weekends.isSubset(of: selectedDays)
        if isWeekendSelected {
            selectedDays.subtract(DayOfWeek.weekends)
        } else {
            selectedDays.formUnion(DayOfWeek.weekends)
        }
        updateButtons()
        listener?.action(.selectWeekday(selectedDays))
    }
    
    @objc
    private func snoozeButtonTapped() {
        listener?.action(.snoozeButtonTapped)
    }
    
    @objc
    private func soundButtonTapped() {
        listener?.action(.soundButtonTapped)
    }
}

private extension SelectWeekDayView {
    func setupUI() {
        backgroundColor = R.Color.gray800
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        weekdayRepeatLabel.do {
            $0.displayText = "요일 반복".displayText(font: .body1SemiBold, color: R.Color.white100)
        }
        weekdayToggleButton.do {
            $0.setImage(FeatureResourcesAsset.icoCheck.image.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = R.Color.gray400
            $0.setAttributedTitle("평일".displayText(font: .label1Medium), for: .normal)
            $0.addTarget(self, action: #selector(weekdayToggleButtonTapped), for: .touchUpInside)
        }
        weekendToggleButton.do {
            $0.setImage(FeatureResourcesAsset.icoCheck.image.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = R.Color.gray400
            $0.setAttributedTitle("주말".displayText(font: .label1Medium), for: .normal)
            $0.addTarget(self, action: #selector(weekendToggleButtonTapped), for: .touchUpInside)
        }
        sundayButton.do {
            $0.update(title: "일")
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        mondayButton.do {
            $0.update(title: "월")
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        tuesdayButton.do {
            $0.update(title: "화")
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        wednesdayButton.do {
            $0.update(title: "수")
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        thursdayButton.do {
            $0.update(title: "목")
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        fridayButton.do {
            $0.update(title: "금")
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        saturdayButton.do {
            $0.update(title: "토")
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        
        dayButtonsStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .fill
            $0.spacing = 7.17
        }
        
        [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton].forEach {
            $0.backgroundColor = R.Color.gray700
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            dayButtonsStackView.addArrangedSubview($0)
        }
        holidayImageView.do {
            $0.image = FeatureResourcesAsset.svgIcoHoliday.image
            $0.contentMode = .scaleAspectFit
        }
        holidayLabel.do {
            $0.displayText = "공휴일 알람 끄기".displayText(font: .label1Medium, color: R.Color.gray300)
        }
        
        holidayToggle.do {
            $0.onTintColor = R.Color.main100
            $0.tintColor = R.Color.gray600
            $0.thumbTintColor = R.Color.gray300
            $0.addTarget(self, action: #selector(holidayToggleChanged), for: .valueChanged)
        }
        
        snoozeTitleLabel.do {
            $0.displayText = "알람 미루기".displayText(font: .body1SemiBold, color: R.Color.white100)
        }
 
        snoozeValueButton.do {
            $0.setAttributedTitle("5분, 무한".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
            $0.addTarget(self, action: #selector(snoozeButtonTapped), for: .touchUpInside)
        }
        
        soundTitleLabel.do {
            $0.displayText = "사운드".displayText(font: .body1SemiBold, color: R.Color.white100)
        }
        
        soundValueButton.do {
            $0.setAttributedTitle("진동, 알림음1".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
            $0.addTarget(self, action: #selector(soundButtonTapped), for: .touchUpInside)
        }
        
        [
            weekdayRepeatLabel, weekdayToggleButton, weekendToggleButton,
            dayButtonsStackView,
            holidayImageView, holidayLabel, holidayToggle,
            snoozeDivider, snoozeTitleLabel, snoozeValueButton,
            soundDivider, soundTitleLabel, soundValueButton
        ].forEach {
            addSubview($0)
        }
    }
    
    func layout() {
        weekdayRepeatLabel.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.equalTo(20)
        }
        
        weekendToggleButton.snp.makeConstraints {
            $0.trailing.equalTo(-20)
            $0.centerY.equalTo(weekdayRepeatLabel)
        }
        
        weekdayToggleButton.snp.makeConstraints {
            $0.trailing.equalTo(weekendToggleButton.snp.leading).offset(-2)
            $0.centerY.equalTo(weekdayRepeatLabel)
        }
        
        dayButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(weekdayRepeatLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalTo(button.snp.width)
            }
        }
        
        holidayToggle.snp.makeConstraints {
            $0.top.equalTo(dayButtonsStackView.snp.bottom).offset(18)
            $0.trailing.equalTo(-20)
        }
        
        holidayImageView.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.centerY.equalTo(holidayToggle)
            $0.size.equalTo(12)
        }
        holidayLabel.snp.makeConstraints {
            $0.leading.equalTo(holidayImageView.snp.trailing).offset(4)
            $0.centerY.equalTo(holidayToggle)
        }
        
        snoozeDivider.snp.makeConstraints {
            $0.top.equalTo(holidayToggle.snp.bottom).offset(19)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        snoozeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(snoozeDivider.snp.bottom).offset(14)
            $0.leading.equalTo(20)
        }
        
        snoozeValueButton.snp.makeConstraints {
            $0.trailing.equalTo(-20)
            $0.centerY.equalTo(snoozeTitleLabel)
        }
        
        soundDivider.snp.makeConstraints {
            $0.top.equalTo(snoozeTitleLabel.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        soundTitleLabel.snp.makeConstraints {
            $0.top.equalTo(soundDivider.snp.bottom).offset(14)
            $0.leading.equalTo(20)
            $0.bottom.equalTo(-14)
        }
        
        soundValueButton.snp.makeConstraints {
            $0.trailing.equalTo(-20)
            $0.centerY.equalTo(soundTitleLabel)
        }
    }
}

private extension SelectWeekDayView {
    private func toggleDay(day: DayOfWeek) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
        updateButtons()
    }
    
    func updateButtons() {
        updateDayOfWeekButtons()
        updateToggleButtons()
    }
    
    func updateDayOfWeekButtons() {
        if isWeekendDisabled {
            selectedDays.subtract(DayOfWeek.weekends)
            sundayButton.update(state: .disabled)
            sundayButton.isEnabled = false
            
            saturdayButton.update(state: .disabled)
            saturdayButton.isEnabled = false
        } else {
            sundayButton.update(state: selectedDays.contains(.sunday) ? .selected : .normal)
            sundayButton.isEnabled = true
            
            saturdayButton.update(state: selectedDays.contains(.saturday) ? .selected : .normal)
            saturdayButton.isEnabled = true
        }
        
        mondayButton.update(state: selectedDays.contains(.monday) ? .selected : .normal)
        tuesdayButton.update(state: selectedDays.contains(.tuesday) ? .selected : .normal)
        wednesdayButton.update(state: selectedDays.contains(.wednesday) ? .selected : .normal)
        thursdayButton.update(state: selectedDays.contains(.thursday) ? .selected : .normal)
        fridayButton.update(state: selectedDays.contains(.friday) ? .selected : .normal)
    }
    
    func updateToggleButtons() {
        // 평일 반복 버튼
        let isWeekdaySelected = DayOfWeek.weekdays.isSubset(of: selectedDays)
        weekdayToggleButton.tintColor = isWeekdaySelected ? R.Color.main100 : R.Color.gray400
        
        // 주말 반복 버튼
        let isWeekendSelected = DayOfWeek.weekends.isSubset(of: selectedDays)
        weekendToggleButton.tintColor = isWeekendSelected ? R.Color.main100 : R.Color.gray400
    }
}
