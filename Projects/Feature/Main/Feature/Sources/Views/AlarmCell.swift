//
//  AlarmCell.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

import UIKit

import FeatureResources
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

final class AlarmCell: UITableViewCell {
    
    // Id
    static let identifier = String(describing: AlarmCell.self)
    
    
    // Action
    enum Action {
        case toggleIsTapped(willMoveTo: AlarmCellState)
        case cellIsLongPressed
    }
    
    
    // Listener
    var action: ((Action) -> Void)?
    
    
    // Gesture
    private let longPressGesture: UILongPressGestureRecognizer = .init()
    
    
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
    
    private let toggleView: UISwitch = .init()
    
    private let containerView: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .center
    }
    
    // State
    private var currentAlarm: Alarm?
    private var state: AlarmCellState = .active
    
    
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
            make.horizontalEdges.equalToSuperview().inset(22)
        }
    }
    
    func setupGesture() {
        // longPressGesture
        contentView.addGestureRecognizer(longPressGesture)
        longPressGesture.addTarget(self, action: #selector(onLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        
        // Toggle
        toggleView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    @objc
    func onLongPress(_ sender: UILongPressGestureRecognizer) {
        action?(.cellIsLongPressed)
    }
    @objc func switchChanged(_ sender: UISwitch) {
        action?(.toggleIsTapped(willMoveTo: sender.isOn ? .active : .inactive))
    }
}


// MARK: Public interface
extension AlarmCell {
    @discardableResult
    func update(renderObject: Alarm, animated: Bool = true) -> Self {
        // State
        self.state = renderObject.isActive ? .active : .inactive
        
        // Toggle
        toggleView.setOn(state == .active, animated: animated)
        
        // day
        let repeatDays = renderObject.repeatDays
        everyWeekLabel.isHidden = repeatDays.days.isEmpty
        holidayImage.isHidden = !renderObject.repeatDays.shoundTurnOffHolidayAlarm
        everyWeekLabel.displayText = everyWeekLabel.displayText?.string.displayText(
            font: .label1SemiBold,
            color: state.dayLabelColor
        )
        let dayDisplayText = if !repeatDays.days.isEmpty {
            repeatDays.days.map { $0.toShortKoreanFormat }.joined(separator: ", ")
        } else {
            "음.."
        }
        dayLabel.displayText = dayDisplayText.displayText(
            font: .label1SemiBold,
            color: state.dayLabelColor
        )
        holidayImage.tintColor = state.dayLabelColor
        
        // clock
        meridiemLabel.displayText = renderObject.meridiem.toKoreanFormat.displayText(
            font: .title2Medium,
            color: state.clockLabelColor
        )
        hourAndMinuteLabel.displayText = String(format: "%02d:%02d", renderObject.hour.value, renderObject.minute.value).displayText(
            font: .title2Medium,
            color: state.clockLabelColor
        )
        return self
    }
    
    enum AlarmCellState {
        case active
        case inactive
        
        var dayLabelColor: UIColor {
            switch self {
            case .active:
                R.Color.gray300
            case .inactive:
                R.Color.gray500
            }
        }
        
        var clockLabelColor: UIColor {
            switch self {
            case .active:
                R.Color.white100
            case .inactive:
                R.Color.gray500
            }
        }
    }
}


// MARK: Previews
#Preview("공휴일 미포함") {
    AlarmCell()
        .update(renderObject: .init(
            meridiem: .am,
            hour: Hour(1)!,
            minute: Minute(5)!,
            repeatDays: AlarmDays(days: [.monday, .thursday, .wednesday, .friday, .tuesday], shoundTurnOffHolidayAlarm: true),
            snoozeOption: SnoozeOption(isSnoozeOn: false, frequency: .fiveMinutes, count: .fiveTimes),
            soundOption: SoundOption(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: ""),
            isActive: true
        ))
}
#Preview("공휴일 포함") {
    AlarmCell()
        .update(renderObject: .init(
            meridiem: .am,
            hour: Hour(1)!,
            minute: Minute(5)!,
            repeatDays: AlarmDays(days: [.monday, .thursday, .wednesday, .friday, .tuesday], shoundTurnOffHolidayAlarm: false),
            snoozeOption: SnoozeOption(isSnoozeOn: false, frequency: .fiveMinutes, count: .fiveTimes),
            soundOption: SoundOption(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: ""),
            isActive: true
        ))
}
#Preview("반복없는 특정일") {
    AlarmCell()
        .update(renderObject: .init(
            meridiem: .am,
            hour: Hour(1)!,
            minute: Minute(5)!,
            repeatDays: AlarmDays(days: []),
            snoozeOption: SnoozeOption(isSnoozeOn: false, frequency: .fiveMinutes, count: .fiveTimes),
            soundOption: SoundOption(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: ""),
            isActive: true
        ))
}
