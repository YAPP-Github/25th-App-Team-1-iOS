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

enum WeekDay {
    case sunday
    case monday
    case tuesday
    case wednesDay
    case thursday
    case friday
    case saturday
}

final class SelectWeekDayView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var selectedDays = Set<Weekday>()
    
    private let weekDayRepeatLabel = UILabel()
    private let weekDayToggleButton = UIButton()
    private let weekendToggleButton = UIButton()
    
    private let sundayButton = UIButton()
    private let mondayButton = UIButton()
    private let tuesdayButton = UIButton()
    private let wednesdayButton = UIButton()
    private let thursdayButton = UIButton()
    private let fridayButton = UIButton()
    private let saturdayButton = UIButton()
    
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
    }
    
    private func toggleDay(day: Weekday) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
        updateDayButtons()
    }
    
    private func updateDayButtons() {
        sundayButton.isSelected = selectedDays.contains(.sunday)
        mondayButton.isSelected = selectedDays.contains(.monday)
        tuesdayButton.isSelected = selectedDays.contains(.tuesday)
        wednesdayButton.isSelected = selectedDays.contains(.wednesday)
        thursdayButton.isSelected = selectedDays.contains(.thursday)
        fridayButton.isSelected = selectedDays.contains(.friday)
        saturdayButton.isSelected = selectedDays.contains(.saturday)
    }
}

private extension SelectWeekDayView {
    func setupUI() {
        backgroundColor = R.Color.gray800
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        weekDayRepeatLabel.do {
            $0.displayText = "요일 반복".displayText(font: .body1SemiBold, color: R.Color.white100)
        }
        weekDayToggleButton.do {
            $0.setImage(FeatureResourcesAsset.icoCheck.image, for: .normal)
            $0.setAttributedTitle("평일".displayText(font: .label1Medium, color: R.Color.gray400), for: .normal)
            $0.setAttributedTitle("평일".displayText(font: .label1Medium, color: R.Color.main100), for: .selected)
        }
        weekendToggleButton.do {
            $0.setImage(FeatureResourcesAsset.icoCheck.image, for: .normal)
            $0.setAttributedTitle("주말".displayText(font: .label1Medium, color: R.Color.gray400), for: .normal)
            $0.setAttributedTitle("주말".displayText(font: .label1Medium, color: R.Color.main100), for: .selected)
        }
        sundayButton.do {
            $0.setAttributedTitle("일".displayText(font: .body1Medium, color: R.Color.gray300), for: .normal)
            $0.setAttributedTitle("일".displayText(font: .body1Medium, color: R.Color.main100), for: .selected)
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        mondayButton.do {
            $0.setAttributedTitle("월".displayText(font: .body1Medium, color: R.Color.gray300), for: .normal)
            $0.setAttributedTitle("월".displayText(font: .body1Medium, color: R.Color.main100), for: .selected)
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        tuesdayButton.do {
            $0.setAttributedTitle("화".displayText(font: .body1Medium, color: R.Color.gray300), for: .normal)
            $0.setAttributedTitle("화".displayText(font: .body1Medium, color: R.Color.main100), for: .selected)
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        wednesdayButton.do {
            $0.setAttributedTitle("수".displayText(font: .body1Medium, color: R.Color.gray300), for: .normal)
            $0.setAttributedTitle("수".displayText(font: .body1Medium, color: R.Color.main100), for: .selected)
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        thursdayButton.do {
            $0.setAttributedTitle("목".displayText(font: .body1Medium, color: R.Color.gray300), for: .normal)
            $0.setAttributedTitle("목".displayText(font: .body1Medium, color: R.Color.main100), for: .selected)
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        fridayButton.do {
            $0.setAttributedTitle("금".displayText(font: .body1Medium, color: R.Color.gray300), for: .normal)
            $0.setAttributedTitle("금".displayText(font: .body1Medium, color: R.Color.main100), for: .selected)
            $0.addTarget(self, action: #selector(dayButtonTapped), for: .touchUpInside)
        }
        saturdayButton.do {
            $0.setAttributedTitle("토".displayText(font: .body1Medium, color: R.Color.gray300), for: .normal)
            $0.setAttributedTitle("토".displayText(font: .body1Medium, color: R.Color.main100), for: .selected)
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
        }
        
        soundTitleLabel.do {
            $0.displayText = "사운드".displayText(font: .body1SemiBold, color: R.Color.white100)
        }
        
        soundValueButton.do {
            $0.setAttributedTitle("진동, 알림음1".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        }
        
        [
            weekDayRepeatLabel, weekDayToggleButton, weekendToggleButton,
            dayButtonsStackView,
            holidayImageView, holidayLabel, holidayToggle,
            snoozeDivider, snoozeTitleLabel, snoozeValueButton,
            soundDivider, soundTitleLabel, soundValueButton
        ].forEach {
            addSubview($0)
        }
    }
    
    func layout() {
        weekDayRepeatLabel.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.equalTo(20)
        }
        
        weekendToggleButton.snp.makeConstraints {
            $0.trailing.equalTo(-20)
            $0.centerY.equalTo(weekDayRepeatLabel)
        }
        
        weekDayToggleButton.snp.makeConstraints {
            $0.trailing.equalTo(weekendToggleButton.snp.leading).offset(-2)
            $0.centerY.equalTo(weekDayRepeatLabel)
        }
        
        dayButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(weekDayRepeatLabel.snp.bottom).offset(12)
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
