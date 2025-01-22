//
//  CreateAlarmSnoozeOptionView.swift
//  FeatureAlarm
//
//  Created by ever on 1/20/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources
import FeatureDesignSystem

protocol CreateAlarmSnoozeOptionViewListener: AnyObject {
    func action(_ action: CreateAlarmSnoozeOptionView.Action)
}

final class CreateAlarmSnoozeOptionView: UIView {
    enum Action {
        case doneButtonTapped
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: CreateAlarmSnoozeOptionViewListener?
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let onOffSwitch = UISwitch()
    
    private let frequencyView = UIView()
    private let countView = UIView()
    
    private let guideView = UIView()
    private let guideLabel = UILabel()
    private let doneButton = DSDefaultCTAButton(initialState: .active, style: .init(type: .secondary))
    
    @objc
    private func onOffSwitchChanged(toggle: UISwitch) {
        
    }
}

private extension CreateAlarmSnoozeOptionView {
    func setupUI() {
        backgroundColor = R.Color.gray900.withAlphaComponent(0.8)
        containerView.do {
            $0.backgroundColor = R.Color.gray800
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.cornerRadius = 28
            $0.layer.masksToBounds = true
        }
        
        titleLabel.do {
            $0.displayText = "알람 미루가".displayText(font: .heading2SemiBold, color: R.Color.white100)
        }
        onOffSwitch.do {
            $0.onTintColor = R.Color.main100
            $0.tintColor = R.Color.gray600
            $0.thumbTintColor = R.Color.gray300
            $0.addTarget(self, action: #selector(onOffSwitchChanged), for: .valueChanged)
        }
        
        guideView.do {
            $0.backgroundColor = R.Color.gray700
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
        }
        
        guideLabel.do {
            $0.displayText = "5분 간격으로 5회 울립니다.".displayText(font: .label1Medium, color: R.Color.main100)
        }
        
        doneButton.do {
            $0.update(title: "완료")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.doneButtonTapped)
            }
        }
        addSubview(containerView)
        guideView.addSubview(guideLabel)
        [titleLabel, onOffSwitch, frequencyView, countView, guideView, doneButton].forEach { containerView.addSubview($0) }
    }
    
    func layout() {
        containerView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
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
            $0.height.equalTo(96)
        }
        
        countView.snp.makeConstraints {
            $0.top.equalTo(frequencyView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(96)
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
            $0.bottom.equalToSuperview()
        }
    }
}
