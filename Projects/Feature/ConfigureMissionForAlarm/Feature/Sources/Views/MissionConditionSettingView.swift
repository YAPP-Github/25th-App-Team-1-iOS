//
//  MissionConditionSettingView.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/23/25.
//

import UIKit

import FeatureUIDependencies

import Lottie

final class MissionConditionSettingView: UIView {
    
    // UI
    private let missionThumbnailContainer = UIView()
    private let missionThumbnailView: LottieAnimationView = .init()
    
    // Count buttons
    private let missionConditionTitleLabel: UILabel = .init()
    private let conditionGuideLabel1 : UILabel = .init()
    private let conditionGuideLabel2 : UILabel = .init()
    private let option1Button = MissionOptionButton()
    private let option1Label = UILabel()
    private let option2Button = MissionOptionButton()
    private let option2Label = UILabel()
    private let option3Button = MissionOptionButton()
    private let option3Label = UILabel()
    private let option4Button = MissionOptionButton()
    private let option4Label = UILabel()
    private let option5Button = MissionOptionButton()
    private let option5Label = UILabel()
    
    private var optionButtons: [MissionOptionButton] {
        [option1Button, option2Button, option3Button, option4Button, option5Button]
    }
    
    private var optionLabels: [UILabel] {
        [option1Label, option2Label, option3Label, option4Label, option5Label]
    }
    
    private let conditionGuideLabelStack = UIStackView()
    private let lineContainer = UIView()
    private let lineView = UIView()
    private let buttonStackView = UIStackView()
    private let titleStackView = UIStackView()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Setup
private extension MissionConditionSettingView {
    
    func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray800
        
        
        // missionThumbnailContainer
        missionThumbnailContainer.layer.cornerRadius = 16
        missionThumbnailContainer.backgroundColor = R.Color.gray700
        missionThumbnailContainer.clipsToBounds = true
        addSubview(missionThumbnailContainer)
        
        
        // missionThumbnailView
        missionThumbnailView.contentMode = .scaleAspectFit
        missionThumbnailView.loopMode = .loop
        missionThumbnailView.animationSpeed = 1
        missionThumbnailContainer.addSubview(missionThumbnailView)
        
        
        // missionConditionTitleLabel
        missionConditionTitleLabel.do {
            $0.displayText = "횟수".displayText(font: .headline2Medium, color: R.Color.white100)
        }
        
        
        // condtionGuideLabels
        conditionGuideLabel1.displayText = "쉬움".displayText(font: .label2SemiBold, color: R.Color.gray300)
        conditionGuideLabel2.displayText = "어려움".displayText(font: .label2SemiBold, color: R.Color.gray300)
        [conditionGuideLabel1, conditionGuideLabel2].forEach { conditionGuideLabelStack.addArrangedSubview($0) }
        
        
        // conditionGuideLabelStack
        conditionGuideLabelStack.distribution = .equalSpacing
        conditionGuideLabelStack.axis = .horizontal
        
        
        // lineView
        lineView.do {
            $0.backgroundColor = R.Color.gray600
        }
        
        
        // buttonStackView
        buttonStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .equalSpacing
        }
        
        
        // titleStackView
        titleStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .equalSpacing
        }
        
        
        [lineView, buttonStackView].forEach { lineContainer.addSubview($0) }
        
        
        // optionButtons
        optionButtons.forEach {
            buttonStackView.addArrangedSubview($0)
            $0.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        }
        
        
        // optionLabels
        optionLabels.forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        
        [missionConditionTitleLabel, conditionGuideLabelStack, lineContainer, titleStackView].forEach {
            addSubview($0)
        }
    }
    
    func setupLayout() {
        
        // missionThumbnailContainer
        missionThumbnailContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(180)
        }
        
        
        // missionThumbnailView
        missionThumbnailView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        // missionConditionTitleLabel
        missionConditionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(missionThumbnailContainer.snp.bottom).offset(28)
            $0.leading.equalToSuperview().inset(24)
        }
        
        
        // conditionGuideLabelStack
        conditionGuideLabelStack.snp.makeConstraints {
            $0.top.equalTo(missionConditionTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        
        // lineContainer
        lineContainer.snp.makeConstraints {
            $0.top.equalTo(conditionGuideLabelStack.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(29.5)
            $0.height.equalTo(20)
        }
        
        
        // lineView
        lineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(18.5)
            $0.height.equalTo(8)
            $0.centerY.equalToSuperview()
        }
        
        
        // buttonStackView
        buttonStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(5.5)
            $0.verticalEdges.equalToSuperview()
        }
        
        
        // titleStackView
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(lineContainer.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualToSuperview().inset(74)
        }
    }
    
    @objc
    private func buttonSelected(button: MissionOptionButton) {
        guard let buttonIndex = optionButtons.firstIndex(where: { $0 == button }) else { return }
        
    }
}


// MARK: Update
extension MissionConditionSettingView {
    
    enum Update {
        case changeMissionItem(item: MissionItemRenderObject)
    }
    
    func update(_ update: Update) {
        switch update {
        case .changeMissionItem(let item):
            
            if missionThumbnailView.isAnimationPlaying {
                missionThumbnailView.stop()
            }
            
            let lottieAnimation = LottieAnimation.filepath(item.guideLottiePath)
            missionThumbnailView.animation = lottieAnimation
            missionThumbnailView.play()
        }
    }
}
