//
//  AlarmCell.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

import UIKit

import FeatureResources

import Then
import SnapKit

protocol AlarmCellListener: AnyObject {
    func action(_ action: AlarmCell.Action)
}

final class AlarmCell: UITableViewCell {
    
    // Action
    enum Action {
        case cellStateChanged(state: AlarmCellState)
    }
    
    
    // Listener
    weak var listener: AlarmCellListener?
    
    
    // Suv view
    // - Label
    private let everyWeekLabel: UILabel = .init()
    private let dayLabel: UILabel = .init()
    private let dayLabelStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.spacing = 4
    }
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
    private var state: AlarmCellState = .active
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        
        // MARK: Temp
        toggleView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    required init?(coder: NSCoder) { nil }
    
    @objc func switchChanged(_ sender: UISwitch) {
        update(state: sender.isOn ? .active : .inactive, animated: true)
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
        
        
        // dayLabelStack
        [everyWeekLabel, dayLabel, UIView()].forEach {
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
        
        // containerView
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(22)
        }
    }
}


// MARK: Public interface
extension AlarmCell {
    @discardableResult
    func update(dayText: String, isEveryWeek: Bool) -> Self {
        dayLabel.displayText = dayText.displayText(
            font: .label1SemiBold,
            color: R.Color.gray300
        )
        everyWeekLabel.isHidden = !isEveryWeek
        return self
    }
    
    enum Meridiem {
        case am, pm
        var korText: String {
            switch self {
            case .am:
                "오전"
            case .pm:
                "오후"
            }
        }
    }
    
    @discardableResult
    func update(hour: Int, minute: Int?, meridiem: Meridiem) -> Self {
        meridiemLabel.displayText = meridiem.korText.displayText(
            font: .title2Medium,
            color: R.Color.white100
        )
        var hourText = "00"
        if hour < 10 {
            hourText = "0\(hour)"
        } else {
            hourText = "\(hour)"
        }
        var minuteText = "00"
        if let minute {
            if minute < 10 {
                minuteText = "0\(minute)"
            } else {
                minuteText = "\(minute)"
            }
        }
        hourAndMinuteLabel.displayText = "\(hourText):\(minuteText)".displayText(
            font: .title2Medium, color: R.Color.white100
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
    
    
    @discardableResult
    func update(state: AlarmCellState, animated: Bool = true) -> Self {
        // State
        self.state = state
        
        // Toggle
        toggleView.setOn(state == .active, animated: animated)
        
        // dayLabel
        everyWeekLabel.displayText = everyWeekLabel.displayText?.string.displayText(
            font: .label1SemiBold,
            color: state.dayLabelColor
        )
        dayLabel.displayText = dayLabel.displayText?.string.displayText(
            font: .label1SemiBold,
            color: state.dayLabelColor
        )
        
        // clock label
        meridiemLabel.displayText = meridiemLabel.displayText?.string.displayText(
            font: .title2Medium,
            color: state.clockLabelColor
        )
        hourAndMinuteLabel.displayText = hourAndMinuteLabel.displayText?.string.displayText(
            font: .title2Medium,
            color: state.clockLabelColor
        )
        
        return self
    }
    
    
}


// MARK: Previews
#Preview {
    AlarmCell()
        .update(dayText: "일, 월, 금", isEveryWeek: true)
        .update(hour: 1, minute: 6, meridiem: .am)
        .update(state: .active)
}
