//
//  AlarmSettingsView.swift
//  FeatureAlarm
//
//  Created by ever on 1/27/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources
import FeatureCommonDependencies

protocol AlarmSettingsViewListener: AnyObject {
    func action(_ action: AlarmSettingsView.Action)
}

final class AlarmSettingsView: UIView {
    enum Action {
        case snoozeButtonTapped
        case soundButtonTapped
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: AlarmSettingsViewListener?
    
    func update(alarm: Alarm) {
        if alarm.snoozeOption.isSnoozeOn {
            snoozeValueButton.setAttributedTitle("\(alarm.snoozeOption.frequency.toKoreanFormat), \(alarm.snoozeOption.count.toKoreanTitleFormat)".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        } else {
            snoozeValueButton.setAttributedTitle("안 함".displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        }
        
        if alarm.soundOption.isSoundOn {
            let selectedSound = alarm.soundOption.selectedSound
            let soundTitle = alarm.soundOption.isVibrationOn ? "진동, \(selectedSound)" : selectedSound
            soundValueButton.setAttributedTitle(soundTitle.displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        } else {
            let soundTitle = alarm.soundOption.isVibrationOn ? "진동" : "안 함"
            soundValueButton.setAttributedTitle(soundTitle.displayText(font: .body2Regular, color: R.Color.gray50), for: .normal)
        }
    }
    
    // MARK: - Views
    private let snoozeContainer = UIView()
    private let snoozeTitleLabel = UILabel()
    private let snoozeValueButton = UIButton()
    private let snoozeContainerButton = UIButton()
    
    private let soundContainer = UIView()
    private let soundDivider = UIView()
    private let soundTitleLabel = UILabel()
    private let soundValueButton = UIButton()
    private let soundContainerButton = UIButton()
    
    @objc
    private func snoozeButtonTapped() {
        listener?.action(.snoozeButtonTapped)
    }
    
    @objc
    private func soundButtonTapped() {
        listener?.action(.soundButtonTapped)
    }
}

private extension AlarmSettingsView {
    func setupUI() {
        backgroundColor = R.Color.gray800
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        snoozeTitleLabel.do {
            $0.displayText = "알람 미루기".displayText(font: .body1SemiBold, color: R.Color.white100)
        }
 
        snoozeValueButton.do {
            $0.semanticContentAttribute = .forceRightToLeft
            $0.setImage(FeatureResourcesAsset.svgChevronRight.image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        snoozeContainerButton.addTarget(self, action: #selector(snoozeButtonTapped), for: .touchUpInside)
        
        soundTitleLabel.do {
            $0.displayText = "사운드".displayText(font: .body1SemiBold, color: R.Color.white100)
        }
        
        soundDivider.do {
            $0.backgroundColor = R.Color.gray700
        }
        
        soundValueButton.do {
            $0.semanticContentAttribute = .forceRightToLeft
            $0.setImage(FeatureResourcesAsset.svgChevronRight.image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        soundContainerButton.addTarget(self, action: #selector(soundButtonTapped), for: .touchUpInside)
        
        [snoozeTitleLabel, snoozeValueButton, snoozeContainerButton].forEach {
            snoozeContainer.addSubview($0)
        }
        
        [soundDivider, soundTitleLabel, soundValueButton, soundContainerButton].forEach {
            soundContainer.addSubview($0)
        }
        
        [snoozeContainer, soundContainer].forEach {
            addSubview($0)
        }
    }
    
    func layout() {
        snoozeContainer.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
        }
        
        snoozeTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
        }
        
        snoozeValueButton.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.centerY.equalTo(snoozeTitleLabel)
        }
        
        snoozeContainerButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        soundDivider.snp.makeConstraints {
            $0.top.equalTo(snoozeContainer.snp.bottom)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        soundContainer.snp.makeConstraints {
            $0.top.equalTo(soundDivider.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview()
        }
        
        soundTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
        }
        
        soundValueButton.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.centerY.equalTo(soundTitleLabel)
        }
        
        soundContainerButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}