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
import FeatureCommonDependencies

protocol SelectWeekDayViewListener: AnyObject {
    func action(_ action: SelectWeekDayView.Action)
}

final class SelectWeekDayView: UIView {
    enum Action {
        case selectWeekday(AlarmDays)
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
        
        if alarm.snoozeOption.isSnoozeOn {
            snoozeValueButton.setAttributedTitle("\(alarm.snoozeOption.frequency.toKoreanFormat), \(alarm.snoozeOption.count.toKoreanTitleFormat)".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        } else {
            snoozeValueButton.setAttributedTitle("안 함".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        }
        
        if alarm.soundOption.isSoundOn {
            let selectedSound = alarm.soundOption.selectedSound
            let soundTitle = alarm.soundOption.isVibrationOn ? "진동, \(selectedSound)" : selectedSound
            soundValueButton.setAttributedTitle(soundTitle.displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        } else {
            let soundTitle = alarm.soundOption.isVibrationOn ? "진동" : "안 함"
            soundValueButton.setAttributedTitle(soundTitle.displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        }
    }
    
    // MARK: - Properties
    private var selectedDays = AlarmDays()
    
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
    
    private let snoozeContainer = UIView()
    private let snoozeDivider = UIView()
    private let snoozeTitleLabel = UILabel()
    private let snoozeValueButton = UIButton()
    private let snoozeContainerButton = UIButton()
    
    private let soundContainer = UIView()
    private let soundDivider = UIView()
    private let soundTitleLabel = UILabel()
    private let soundValueButton = UIButton()
    private let soundContainerButton = UIButton()
    
    @objc
    private func holidayToggleChanged(toggle: UISwitch) {
        selectedDays.shoundTurnOffHolidayAlarm = toggle.isOn
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
        let isWeekdaySelected = WeekDay.weekdays.isSubset(of: selectedDays.days)
        if isWeekdaySelected {
            selectedDays.subtract(WeekDay.weekdays)
        } else {
            selectedDays.formUnion(WeekDay.weekdays)
        }
        updateButtons()
        listener?.action(.selectWeekday(selectedDays))
    }
    
    @objc
    private func weekendToggleButtonTapped() {
        let isWeekendSelected = WeekDay.weekends.isSubset(of: selectedDays.days)
        if isWeekendSelected {
            selectedDays.subtract(WeekDay.weekends)
        } else {
            selectedDays.formUnion(WeekDay.weekends)
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
            $0.semanticContentAttribute = .forceRightToLeft // 추후 수정 예정
            $0.setImage(FeatureResourcesAsset.svgChevronRight.image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        snoozeContainerButton.addTarget(self, action: #selector(snoozeButtonTapped), for: .touchUpInside)
        
        soundTitleLabel.do {
            $0.displayText = "사운드".displayText(font: .body1SemiBold, color: R.Color.white100)
        }
        
        [snoozeDivider, soundDivider].forEach {
            $0.backgroundColor = R.Color.gray700
        }
        
        soundValueButton.do {
            $0.semanticContentAttribute = .forceRightToLeft // 추후 수정 예정
            $0.setImage(FeatureResourcesAsset.svgChevronRight.image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        soundContainerButton.addTarget(self, action: #selector(soundButtonTapped), for: .touchUpInside)
        
        [snoozeDivider, snoozeTitleLabel, snoozeValueButton, snoozeContainerButton].forEach {
            snoozeContainer.addSubview($0)
        }
        
        [soundDivider, soundTitleLabel, soundValueButton, soundContainerButton].forEach {
            soundContainer.addSubview($0)
        }
        
        [
            weekdayRepeatLabel, weekdayToggleButton, weekendToggleButton,
            dayButtonsStackView,
            holidayImageView, holidayLabel, holidayToggle,
            snoozeContainer,
            soundContainer
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
            $0.width.equalTo(46)
            $0.height.equalTo(26)
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
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        snoozeContainer.snp.makeConstraints {
            $0.top.equalTo(snoozeDivider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        snoozeTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
        }
        
        snoozeValueButton.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.centerY.equalTo(snoozeTitleLabel)
        }
        
        snoozeContainerButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        soundDivider.snp.makeConstraints {
            $0.top.equalTo(snoozeContainer.snp.bottom)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        soundContainer.snp.makeConstraints {
            $0.top.equalTo(soundDivider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview()
        }
        
        soundTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
        }
        
        soundValueButton.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.centerY.equalTo(soundTitleLabel)
        }
        
        soundContainerButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension SelectWeekDayView {
    private func toggleDay(day: WeekDay) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.add(day)
        }
        updateButtons()
    }
    
    func updateButtons() {
        updateDayOfWeekButtons()
        updateToggleButtons()
    }
    
    func updateDayOfWeekButtons() {
        sundayButton.update(state: selectedDays.contains(.sunday) ? .selected : .normal)
        mondayButton.update(state: selectedDays.contains(.monday) ? .selected : .normal)
        tuesdayButton.update(state: selectedDays.contains(.tuesday) ? .selected : .normal)
        wednesdayButton.update(state: selectedDays.contains(.wednesday) ? .selected : .normal)
        thursdayButton.update(state: selectedDays.contains(.thursday) ? .selected : .normal)
        fridayButton.update(state: selectedDays.contains(.friday) ? .selected : .normal)
        saturdayButton.update(state: selectedDays.contains(.saturday) ? .selected : .normal)
    }
    
    func updateToggleButtons() {
        // 평일 반복 버튼
        let isWeekdaySelected = WeekDay.weekdays.isSubset(of: selectedDays.days)
        weekdayToggleButton.tintColor = isWeekdaySelected ? R.Color.main100 : R.Color.gray400
        
        // 주말 반복 버튼
        let isWeekendSelected = WeekDay.weekends.isSubset(of: selectedDays.days)
        weekendToggleButton.tintColor = isWeekendSelected ? R.Color.main100 : R.Color.gray400
        
        if selectedDays.days.isEmpty {
            holidayToggle.isEnabled = false
            holidayToggle.isOn = false
        } else {
            holidayToggle.isEnabled = true
            holidayToggle.isOn = selectedDays.shoundTurnOffHolidayAlarm
        }
        holidayToggle.thumbTintColor = selectedDays.shoundTurnOffHolidayAlarm ? R.Color.gray800 : R.Color.gray300
    }
}
