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
    
    // Id
    static let identifier = String(describing: AlarmCell.self)
    
    
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
        listener?.action(.cellStateChanged(state: sender.isOn ? .active : .inactive))
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
}


// MARK: Public interface
extension AlarmCell {
    @discardableResult
    func update(renderObject: AlarmCellRO, animated: Bool = true) -> Self {
        // State
        self.state = renderObject.isActive ? .active : .inactive
        
        // Toggle
        toggleView.setOn(state == .active, animated: animated)
        
        // day
        let iterationType = renderObject.iterationType
        switch iterationType {
        case .everyDays(let days):
            everyWeekLabel.isHidden = false
            holidayImage.isHidden = !days.isRestOnHoliday
        case .specificDay(let month, let day):
            everyWeekLabel.isHidden = true
            holidayImage.isHidden = true
        }
        everyWeekLabel.displayText = everyWeekLabel.displayText?.string.displayText(
            font: .label1SemiBold,
            color: state.dayLabelColor
        )
        let dayDisplayText = iterationType.dayDisplayText
        dayLabel.displayText = dayDisplayText.displayText(
            font: .label1SemiBold,
            color: state.dayLabelColor
        )
        holidayImage.tintColor = state.dayLabelColor
        
        // clock
        meridiemLabel.displayText = renderObject.meridiem.korText.displayText(
            font: .title2Medium,
            color: state.clockLabelColor
        )
        hourAndMinuteLabel.displayText = renderObject.hourAndMinuteDisplayText.displayText(
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
            iterationType: .everyDays(days: [.mon,.thu,.wed,.fri,.tue]),
            meridiem: .am,
            hour: 1,
            minute: 5,
            isActive: true
        ))
}
#Preview("공휴일 포함") {
    AlarmCell()
        .update(renderObject: .init(
            iterationType: .everyDays(days: [.mon,.sun,.tue]),
            meridiem: .am,
            hour: 1,
            minute: 5,
            isActive: true
        ))
}
#Preview("반복없는 특정일") {
    AlarmCell()
        .update(renderObject: .init(
            iterationType: .specificDay(month: 1, day: 2),
            meridiem: .am,
            hour: 1,
            minute: 5,
            isActive: false
        ))
}
