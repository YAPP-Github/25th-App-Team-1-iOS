//
//  AlarmDeletionItemView.swift
//  Main
//
//  Created by choijunios on 2/1/25.
//

import UIKit

import FeatureDesignSystem
import FeatureResources
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

protocol AlarmDeletionItemViewListener: AnyObject {
    func action(_ action: AlarmDeletionItemView.Action)
}

final class AlarmDeletionItemView: UIView {
    
    // Action
    enum Action {
        case toggleIsTapped
    }
    
    
    // Listener
    weak var listener: AlarmDeletionItemViewListener?
    
    
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
    private let toggle: DSToggle = .init(initialState: .init(isEnabled: true, switchState: .on))
    private let containerView: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .center
    }
    
    // State
    private var currentRO: AlarmCellRO?
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Setup
private extension AlarmDeletionItemView {
    func setupUI() {
        
        // self
        self.layer.cornerRadius = 24
        self.layer.borderWidth = 1
        self.layer.borderColor = R.Color.gray700.cgColor
        self.backgroundColor = R.Color.gray800
        
        
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
        
        
        // toggle
        toggle.toggleAction = { [weak self] in
            guard let self else { return }
            listener?.action(.toggleIsTapped)
        }
        
        
        // containerView
        [timeLabelContainer, toggle].forEach {
            containerView.addArrangedSubview($0)
        }
        addSubview(containerView)
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
}


// MARK: Public interface
extension AlarmDeletionItemView {
    @discardableResult
    func update(renderObject ro: AlarmCellRO, animated: Bool = true) -> Self {
        let isAlarmActive = ro.isToggleOn
        
        // Toggle
        toggle.update(state: .init(
            isEnabled: true,
            switchState: isAlarmActive ? .on : .off
        ), animated: animated)
        
        
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
        hourAndMinuteLabel.displayText = String(format: "%d:%02d", ro.hour.value, ro.minute.value).displayText(
            font: .title2Medium,
            color: clockColor
        )
        
        return self
    }
    
    enum AlarmState {
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

//#Preview {
//    AlarmDeletionItemView()
//        .update(renderObject: .init(
//            iterationType: .everyDays(days: [.fri,.mon]),
//            meridiem: .am,
//            hour: 1,
//            minute: 12,
//            isActive: true
//        ))
//}
