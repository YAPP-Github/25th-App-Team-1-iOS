//
//  CreateEditAlarmSnoozeOptionView.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources
import FeatureDesignSystem
import FeatureCommonDependencies

protocol CreateEditAlarmSnoozeOptionViewListener: AnyObject {
    func action(_ action: CreateEditAlarmSnoozeOptionView.Action)
}

final class CreateEditAlarmSnoozeOptionView: UIView {
    enum Action {
        case backgroundTapped
        case isOnChanged(Bool)
        case frequencyChanged(SnoozeFrequency)
        case countChanged(SnoozeCount)
        case doneButtonTapped
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: CreateEditAlarmSnoozeOptionViewListener?
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let onOffSwitch = UISwitch()
    
    private let frequencyView = SnoozeOptionSelectionView(
        title: "간격",
        options: SnoozeFrequency.allCases
    )
    private let countView = SnoozeOptionSelectionView(
        title: "횟수",
        options: SnoozeCount.allCases
    )
    
    private let guideView = UIView()
    private let guideLabel = UILabel()
    private let doneButton = DSDefaultCTAButton(initialState: .active, style: .init(type: .secondary))
    
    // MARK: Internal
    func updateOption(option: SnoozeOption) {
        if option.isSnoozeOn {
            onOffSwitch.isOn = true
            frequencyView.selectOption(option.frequency)
            countView.selectOption(option.count)
            guideView.isHidden = false
            guideLabel.displayText = "\(option.frequency.title) 간격으로 \(option.count.value) 울립니다."
                .displayText(font: .label1Medium, color: R.Color.main100)
            doneButton.snp.remakeConstraints {
                $0.top.equalTo(guideView.snp.bottom).offset(23)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalTo(safeAreaLayoutGuide)
            }
        } else {
            onOffSwitch.isOn = false
            frequencyView.disableOptions()
            countView.disableOptions()
            guideView.isHidden = true
            
            doneButton.snp.remakeConstraints {
                $0.top.equalTo(countView.snp.bottom).offset(40)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            }
        }
    }
    
    @objc
    private func onOffSwitchChanged(toggle: UISwitch) {
        toggle.thumbTintColor = toggle.isOn ? R.Color.gray800 : R.Color.gray300
        listener?.action(.isOnChanged(toggle.isOn))
    }
    
    @objc
    private func backgroundTapped() {
        listener?.action(.backgroundTapped)
    }
}

private extension CreateEditAlarmSnoozeOptionView {
    func setupUI() {
        backgroundView.backgroundColor = R.Color.gray900.withAlphaComponent(0.8)
        containerView.do {
            $0.backgroundColor = R.Color.gray800
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.borderColor = R.Color.gray700.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 28
            $0.layer.masksToBounds = true
        }
        
        titleLabel.do {
            $0.displayText = "알람 미루기".displayText(font: .heading2SemiBold, color: R.Color.white100)
        }
        onOffSwitch.do {
            $0.onTintColor = R.Color.main100
            $0.tintColor = R.Color.gray600
            $0.thumbTintColor = R.Color.gray800
            $0.addTarget(self, action: #selector(onOffSwitchChanged), for: .valueChanged)
            $0.isOn = true
        }
        
        frequencyView.do {
            $0.optionSelected = { [weak self] option in
                guard let self, let frequency = option as? SnoozeFrequency else { return }
                listener?.action(.frequencyChanged(frequency))
            }
        }
        
        countView.do {
            $0.optionSelected = { [weak self] option in
                guard let self,
                      let count = option as? SnoozeCount else { return }
                listener?.action(.countChanged(count))
            }
        }
        
        guideView.do {
            $0.backgroundColor = R.Color.gray700
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
        
        doneButton.do {
            $0.update(title: "완료")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.doneButtonTapped)
            }
        }
        addSubview(backgroundView)
        addSubview(containerView)
        guideView.addSubview(guideLabel)
        [titleLabel, onOffSwitch, frequencyView, countView, guideView, doneButton].forEach { containerView.addSubview($0) }
    }
    
    func layout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(26)
            $0.leading.equalTo(24)
        }
        
        onOffSwitch.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(-24)
        }
        
        frequencyView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview()
        }
        
        countView.snp.makeConstraints {
            $0.top.equalTo(frequencyView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
        }
        
        guideView.snp.makeConstraints {
            $0.top.equalTo(countView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(6)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(guideView.snp.bottom).offset(23)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backgroundView.addGestureRecognizer(gesture)
    }
}
