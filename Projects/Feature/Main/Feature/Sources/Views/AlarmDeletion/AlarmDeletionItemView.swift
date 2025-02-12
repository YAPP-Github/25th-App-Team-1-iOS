//
//  AlarmDeletionItemView.swift
//  Main
//
//  Created by choijunios on 2/1/25.
//

import UIKit

import FeatureResources
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

protocol AlarmDeletionItemViewListener: AnyObject {
    func action(_ action: AlarmDeletionItemView.Action)
}

final class AlarmDeletionItemView: UIView {
    
    // Action
    enum Action {
        case toggleIsTapped(cellId: String, willMoveTo: AlarmState)
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
    
    private let toggleView: UISwitch = .init()
    
    private let containerView: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.alignment = .center
    }
    
    // State
    private var currentRO: AlarmCellRO?
    private var state: AlarmState = .active
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        
        // MARK: Temp
        toggleView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    required init?(coder: NSCoder) { nil }
    
    @objc func switchChanged(_ sender: UISwitch) {
        guard let cellId = self.currentRO?.id else { return }
        listener?.action(.toggleIsTapped(
            cellId: cellId,
            willMoveTo: sender.isOn ? .active : .inactive
        ))
    }
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
        
        
        // toggleView
        // MARK: TEMP
        toggleView.onTintColor = R.Color.main100
        
        
        // containerView
        [timeLabelContainer, toggleView].forEach {
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
        // State
        let isActive = ro.isToggleOn
        self.state = isActive ? .active : .inactive
        self.currentRO = ro
        
        // Toggle
        toggleView.setOn(state == .active, animated: animated)
        
        // day
        let alarmDays = ro.alarmDays
        everyWeekLabel.isHidden = alarmDays.days.isEmpty
        holidayImage.isHidden = !alarmDays.shoundTurnOffHolidayAlarm
        everyWeekLabel.displayText = everyWeekLabel.displayText?.string.displayText(
            font: .label1SemiBold,
            color: state.dayLabelColor
        )
        let dayDisplayText = "매주" + alarmDays.days.map { $0.toShortKoreanFormat }.joined(separator: " ")
        dayLabel.displayText = dayDisplayText.displayText(
            font: .label1SemiBold,
            color: state.dayLabelColor
        )
        holidayImage.tintColor = state.dayLabelColor
        
        // clock
        meridiemLabel.displayText = ro.meridiem.toKoreanFormat.displayText(
            font: .title2Medium,
            color: state.clockLabelColor
        )
        hourAndMinuteLabel.displayText = String(format: "%02d:%02d", ro.hour.value, ro.minute.value).displayText(
            font: .title2Medium,
            color: state.clockLabelColor
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
