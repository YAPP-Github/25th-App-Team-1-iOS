//
//  AlarmCell.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

import UIKit

import FeatureResources
import FeatureDesignSystem
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

final class AlarmCell: UITableViewCell {
    
    // Id
    static let identifier = String(describing: AlarmCell.self)
    
    
    // Action
    enum Action {
        case activityToggleTapped
        case cellIsLongPressed
        case cellIsTapped
    }
    
    
    // Listener
    var action: ((Action) -> Void)?
    
    
    // Gesture
    private let longPressGesture: UILongPressGestureRecognizer = .init()
    private let tapGesture: UITapGestureRecognizer = .init()
    
    
    // Suv view
    // - Label
    private let everyWeekLabel: UILabel = .init()
    private let dayLabel: UILabel = .init()
    private let dayLabelStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
    private let holidayImage: UIImageView = .init()
    private let meridiemLabel: UILabel = .init()
    private let hourAndMinuteLabel: UILabel = .init()
    private let clockLabelStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 6
    }
    private let timeLabelContainer: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }
    // - Delete selection
    private let checkBox: DSCheckBox = .init(initialState: .idle, buttonStyle: .init(size: .medium))
    private var checkBoxRightConstraint: Constraint?
    
    private let toggle: DSToggle = .init(initialState: .init(isEnabled: true, switchState: .off))
    
    private let containerView: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .center
    }
    
    
    // State
    private var currentAlarm: Alarm?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        setupGesture()
    }
    required init?(coder: NSCoder) { nil }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.currentAlarm = nil
    }
}


// MARK: Setup
private extension AlarmCell {
    func setupUI() {
        
        // contentView
        contentView.backgroundColor = R.Color.gray900
        
        
        // everyWeekLabel
        everyWeekLabel.displayText = "매주".displayText(
            font: .label1SemiBold,
            color: R.Color.gray300
        )
        
        
        // holidayImage
        holidayImage.image = FeatureResourcesAsset.holiday.image
        holidayImage.contentMode = .scaleAspectFit
        holidayImage.tintColor = R.Color.gray300
        
        
        // dayLabelStack
        [everyWeekLabel, dayLabel, holidayImage, UIView()].forEach {
            dayLabelStack.addArrangedSubview($0)
        }
        
        
        // clockLabelStack
        [meridiemLabel, hourAndMinuteLabel, UIView()].forEach {
            clockLabelStack.addArrangedSubview($0)
        }
        
        
        // timeLabelContainer
        [dayLabelStack, clockLabelStack].forEach {
            timeLabelContainer.addArrangedSubview($0)
        }
        
        
        // checkBox
        checkBox.isHidden = true
        contentView.addSubview(checkBox)
        
        
        // Toggle view
        toggle.toggleAction = { [weak self] in
            guard let self else { return }
            action?(.activityToggleTapped)
        }
        
        
        // containerView
        [timeLabelContainer, toggle].forEach {
            containerView.addArrangedSubview($0)
        }
        contentView.addSubview(containerView)
    }
    
    func setupLayout() {
        
        // holidayImage
        holidayImage.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        
        
        // containerView
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(22).priority(.high)
        }
        
        
        // checkBox
        checkBox.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            self.checkBoxRightConstraint = make.right.equalTo(containerView.snp.left).offset(-12).constraint
        }
        checkBoxRightConstraint?.deactivate()
    }
    
    func setupGesture() {
        // longPressGesture
        contentView.addGestureRecognizer(longPressGesture)
        longPressGesture.delegate = self
        longPressGesture.addTarget(self, action: #selector(onLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.cancelsTouchesInView = false
        
        
        // tapGesture
        contentView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        tapGesture.addTarget(self, action: #selector(onTap(_:)))
        tapGesture.cancelsTouchesInView = false
    }
    @objc
    func onTap(_ sender: UITapGestureRecognizer) {
        action?(.cellIsTapped)
    }
    @objc
    func onLongPress(_ sender: UILongPressGestureRecognizer) {
        action?(.cellIsLongPressed)
    }
}


// MARK: Public interface
extension AlarmCell {
    @discardableResult
    func update(renderObject ro: AlarmCellRO, animated: Bool = true) -> Self {
        let isAlarmActive = ro.isToggleOn
        
        // Toggle
        toggle.update(state: .init(
            isEnabled: true,
            switchState: isAlarmActive ? .on : .off
        ))
        
        
        // day
        let dayColor = isAlarmActive ? R.Color.gray300 : R.Color.gray500
        let alarmDays = ro.alarmDays
        everyWeekLabel.isHidden = alarmDays.days.isEmpty
        holidayImage.isHidden = !alarmDays.shoundTurnOffHolidayAlarm
        everyWeekLabel.displayText = everyWeekLabel.displayText?.string.displayText(
            font: .label1SemiBold,
            color: dayColor
        )
        var dayDisplayText = ""
        if !alarmDays.days.isEmpty {
            dayDisplayText = alarmDays.days
                .sorted(by: { $0.rawValue < $1.rawValue })
                .map { $0.toShortKoreanFormat }.joined(separator: ", ")
        } else {
            var alarmHour = ro.hour.value
            if ro.meridiem == .pm, (1...11).contains(alarmHour) {
                alarmHour += 12
            }
            let alarmMinute = ro.minute.value
            let currentHour = Calendar.current.component(.hour, from: .now)
            let currentMinute = Calendar.current.component(.minute, from: .now)
            
            // 알람이 현재 시간 이후에 울리는지 확인
            let isTodayAlarm = (alarmHour > currentHour) || (alarmHour == currentHour && alarmMinute > currentMinute)
            var alarmDate: Date = .now
            if !isTodayAlarm {
                // 내일 울릴 알람인 경우
                alarmDate = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
            }
            let month = Calendar.current.component(.month, from: alarmDate)
            let day = Calendar.current.component(.day, from: alarmDate)
            dayDisplayText = "\(month)월 \(day)일"
        }
        dayLabel.displayText = dayDisplayText.displayText(
            font: .label1SemiBold,
            color: dayColor
        )
        holidayImage.tintColor = dayColor
        
        // clock
        let clockColor = isAlarmActive ? R.Color.white100 : R.Color.gray500
        meridiemLabel.displayText = ro.meridiem.toKoreanFormat.displayText(
            font: .title2Medium,
            color: clockColor
        )
        hourAndMinuteLabel.displayText = String(format: "%02d:%02d", ro.hour.value, ro.minute.value).displayText(
            font: .title2Medium,
            color: clockColor
        )
        
        // Mode
        switch ro.mode {
        case .idle:
            checkBox.isHidden = true
            toggle.isHidden = false
            checkBoxRightConstraint?.deactivate()
            contentView.backgroundColor = R.Color.gray900
        case .deletion:
            checkBox.isHidden = false
            toggle.isHidden = true
            checkBoxRightConstraint?.activate()
            checkBox.update(state: ro.isChecked ? .seleceted : .idle)
            contentView.backgroundColor = ro.isChecked ? R.Color.gray800 : R.Color.gray900
        }
        
        return self
    }
}


// MARK: UIGestureRecognizerDelegate
extension AlarmCell {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view === toggle {
            return false
        }
        return true
    }
}
