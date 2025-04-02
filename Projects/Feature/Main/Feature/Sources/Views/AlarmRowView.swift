//
//  AlarmRowView.swift
//  Main
//
//  Created by choijunios on 4/2/25.
//

import UIKit

import FeatureResources
import FeatureDesignSystem
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

import RxSwift
import RxRelay

protocol AlarmRowViewListener: AnyObject {
    func action(_ action: AlarmRowView.Action)
}

final class AlarmRowView: UIView, UIGestureRecognizerDelegate {
    
    // Action
    enum Action {
        case activityToggleTapped
        case cellIsLongPressed
        case cellIsTapped
    }
    
    // Listener
    weak var listener: AlarmRowViewListener?
    
    
    // Gesture
    private let longPressGesture: UILongPressGestureRecognizer = .init()
    private let tapGesture: UITapGestureRecognizer = .init()
    
    
    // Suv view
    // - Label
    private let everyWeekLabel: UILabel = .init()
    private let dayLabel: UILabel = .init()
    private let dayLabelStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.alignment = .center
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
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setupGesture()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Setup
private extension AlarmRowView {
    func setupUI() {
        // contentView
        self.backgroundColor = R.Color.gray900
        
        
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
        self.addSubview(checkBox)
        
        
        // Toggle view
        toggle.toggleAction = { [weak self] in
            guard let self else { return }
            listener?.action(.activityToggleTapped)
        }
        
        
        // containerView
        [timeLabelContainer, UIView(), toggle].forEach {
            containerView.addArrangedSubview($0)
        }
        self.addSubview(containerView)
    }
    
    func setupLayout() {
        
        // holidayImage
        holidayImage.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(12)
        }
        
        
        // dayLabelStack
        dayLabelStack.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        
        // containerView
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
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
        self.addGestureRecognizer(longPressGesture)
        longPressGesture.delegate = self
        longPressGesture.addTarget(self, action: #selector(onLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.cancelsTouchesInView = false
        
        // tapGesture
        self.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        tapGesture.require(toFail: longPressGesture)
        tapGesture.addTarget(self, action: #selector(onTap(_:)))
        tapGesture.cancelsTouchesInView = false
    }
    @objc
    func onTap(_ sender: UITapGestureRecognizer) {
        listener?.action(.cellIsTapped)
    }
    @objc
    func onLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            listener?.action(.cellIsLongPressed)
        }
    }
}


// MARK: Public interface
extension AlarmRowView {
    @discardableResult
    func update(renderObject ro: AlarmCellRO, animated: Bool = true) -> Self {
        let isAlarmActive = ro.isToggleOn
        
        // Toggle
        toggle.update(state: .init(
            isEnabled: true,
            switchState: isAlarmActive ? .on : .off
        ), animated: animated)
        
        
        // '매주' 라벨
        everyWeekLabel.isHidden = (ro.isEveryWeekRepeating == false)
        everyWeekLabel.displayText = everyWeekLabel.displayText?.string.displayText(
            font: .label1SemiBold,
            color: isAlarmActive ? R.Color.gray300 : R.Color.gray500
        )
        
        
        // 알람이 울리는 날짜 정보(월, 화, 수 .. or n월 n일)
        dayLabel.displayText = ro.alarmDayText.displayText(
            font: .label1SemiBold,
            color: isAlarmActive ? R.Color.gray300 : R.Color.gray500
        )
        
        
        // 공휴일 제외
        holidayImage.tintColor = isAlarmActive ? R.Color.gray300 : R.Color.gray500
        holidayImage.isHidden = !ro.isExceptForHoliday
        
        
        // 오전, 오후 라벨
        meridiemLabel.displayText = ro.meridiemText.displayText(
            font: .title2Medium,
            color: isAlarmActive ? R.Color.white100 : R.Color.gray500
        )
        
        
        // 시간 라벨
        hourAndMinuteLabel.displayText = ro.hourAndMinuteText.displayText(
            font: .title2Medium,
            color: isAlarmActive ? R.Color.white100 : R.Color.gray500
        )
        
        
        // 알람 열 모드
        switch ro.alarmRowMode {
        case .idle:
            checkBox.isHidden = true
            toggle.isHidden = false
            checkBoxRightConstraint?.deactivate()
            self.backgroundColor = R.Color.gray900
        case .deletion:
            checkBox.isHidden = false
            toggle.isHidden = true
            checkBoxRightConstraint?.activate()
            checkBox.update(state: ro.isChecked ? .seleceted : .idle)
            self.backgroundColor = ro.isChecked ? R.Color.gray800 : R.Color.gray900
        }
        return self
    }
}


// MARK: UIGestureRecognizerDelegate
extension AlarmRowView {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view === toggle {
            return false
        }
        return true
    }
}
