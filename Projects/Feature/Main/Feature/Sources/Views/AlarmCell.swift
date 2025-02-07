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
        case toggleIsTapped
        case cellIsLongPressed
        case cellIsTapped
        case selectionForDeletion
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
    
    private let toggleView: UISwitch = .init()
    
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
        
        
        // toggleView
        // MARK: TEMP
        toggleView.onTintColor = R.Color.main100
        
        
        // checkBox
        checkBox.isHidden = true
        checkBox.buttonAction = { [weak self] _ in
            guard let self else { return }
            action?(.selectionForDeletion)
        }
        contentView.addSubview(checkBox)
        
        
        // containerView
        [timeLabelContainer, toggleView].forEach {
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
        longPressGesture.addTarget(self, action: #selector(onLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        
        
        // tapGesture
        contentView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(onTap(_:)))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        
        
        // Toggle
        toggleView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    @objc
    func onTap(_ sender: UITapGestureRecognizer) {
        action?(.cellIsTapped)
    }
    @objc
    func onLongPress(_ sender: UILongPressGestureRecognizer) {
        action?(.cellIsLongPressed)
    }
    @objc func switchChanged(_ sender: UISwitch) {
        action?(.toggleIsTapped)
    }
}


// MARK: Public interface
extension AlarmCell {
    @discardableResult
    func update(renderObject: AlarmCellRO, animated: Bool = true) -> Self {
        // self
        self.currentAlarm = renderObject.alarm
        
        let isActive = renderObject.alarm.isActive
        
        // Toggle
        toggleView.setOn(isActive, animated: animated)
        
        // day
        let dayColor = isActive ? R.Color.gray300 : R.Color.gray500
        let repeatDays = renderObject.alarm.repeatDays
        everyWeekLabel.isHidden = repeatDays.days.isEmpty
        holidayImage.isHidden = !renderObject.alarm.repeatDays.shoundTurnOffHolidayAlarm
        everyWeekLabel.displayText = everyWeekLabel.displayText?.string.displayText(
            font: .label1SemiBold,
            color: dayColor
        )
        let dayDisplayText = if !repeatDays.days.isEmpty {
            repeatDays.days.map { $0.toShortKoreanFormat }.joined(separator: ", ")
        } else {
            "음.."
        }
        dayLabel.displayText = dayDisplayText.displayText(
            font: .label1SemiBold,
            color: dayColor
        )
        holidayImage.tintColor = dayColor
        
        // clock
        let clockColor = isActive ? R.Color.white100 : R.Color.gray500
        meridiemLabel.displayText = renderObject.alarm.meridiem.toKoreanFormat.displayText(
            font: .title2Medium,
            color: clockColor
        )
        hourAndMinuteLabel.displayText = String(format: "%02d:%02d", renderObject.alarm.hour.value, renderObject.alarm.minute.value).displayText(
            font: .title2Medium,
            color: clockColor
        )
        
        // Mode
        switch renderObject.mode {
        case .idle:
            checkBox.isHidden = true
            toggleView.isHidden = false
            checkBoxRightConstraint?.deactivate()
        case .deletion:
            checkBox.isHidden = false
            toggleView.isHidden = true
            checkBoxRightConstraint?.activate()
            checkBox.update(state: renderObject.isSelectedForDeleteion ? .seleceted : .idle)
        }
        
        return self
    }
}

// MARK: UIGestureRecognizerDelegate
extension AlarmCell {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view === checkBox {
            return false
        }
        return true
    }
}



//// MARK: Previews
//#Preview("공휴일 미포함") {
//    AlarmCell()
//        .update(renderObject: .init(
//            meridiem: .am,
//            hour: Hour(1)!,
//            minute: Minute(5)!,
//            repeatDays: AlarmDays(days: [.monday, .thursday, .wednesday, .friday, .tuesday], shoundTurnOffHolidayAlarm: true),
//            snoozeOption: SnoozeOption(isSnoozeOn: false, frequency: .fiveMinutes, count: .fiveTimes),
//            soundOption: SoundOption(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: ""),
//            isActive: true
//        ))
//}
//#Preview("공휴일 포함") {
//    AlarmCell()
//        .update(renderObject: .init(
//            meridiem: .am,
//            hour: Hour(1)!,
//            minute: Minute(5)!,
//            repeatDays: AlarmDays(days: [.monday, .thursday, .wednesday, .friday, .tuesday], shoundTurnOffHolidayAlarm: false),
//            snoozeOption: SnoozeOption(isSnoozeOn: false, frequency: .fiveMinutes, count: .fiveTimes),
//            soundOption: SoundOption(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: ""),
//            isActive: true
//        ))
//}
//#Preview("반복없는 특정일") {
//    AlarmCell()
//        .update(renderObject: .init(
//            meridiem: .am,
//            hour: Hour(1)!,
//            minute: Minute(5)!,
//            repeatDays: AlarmDays(days: []),
//            snoozeOption: SnoozeOption(isSnoozeOn: false, frequency: .fiveMinutes, count: .fiveTimes),
//            soundOption: SoundOption(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: ""),
//            isActive: true
//        ))
//}
