//
//  MissionConditionSettingPage.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/31/25.
//

import UIKit

import FeatureResources
import FeatureUIDependencies

import Lottie

final class MissionConditionSettingPage: UIView {
    
    // Action
    enum Action {
        case exitButtonTapped
        case prevButtonTapped
        
        case conditionButtonIsTapped(index: Int)
        
        case previewButtonIsTapped
        case saveButtonIsTapped
    }
    var pageAction: ((Action) -> ())?
    
    
    // UI
    private let navBar: NavigationBar = .init()
    
    private let missionThumbnailContainer: UIView = .init()
    private let missionThumbnailView: LottieAnimationView = .init()
    
    // Count buttons
    private let missionConditionTitleLabel: UILabel = .init()
    private let conditionGuideLabel1: UILabel = .init()
    private let conditionGuideLabel2: UILabel = .init()
    private let option1Button: MissionOptionButton = .init()
    private let option1Label: UILabel = .init()
    private let option2Button: MissionOptionButton = .init()
    private let option2Label: UILabel = .init()
    private let option3Button: MissionOptionButton = .init()
    private let option3Label: UILabel = .init()
    private let option4Button: MissionOptionButton = .init()
    private let option4Label: UILabel = .init()
    private let option5Button: MissionOptionButton = .init()
    private let option5Label: UILabel = .init()
    
    private var optionButtons: [MissionOptionButton] {
        [option1Button, option2Button, option3Button, option4Button, option5Button]
    }
    
    private var optionLabels: [UILabel] {
        [option1Label, option2Label, option3Label, option4Label, option5Label]
    }
    
    private let conditionGuideLabelStack: UIStackView = .init()
    private let lineContainer: UIView = .init()
    private let lineView: UIView = .init()
    private let buttonStackView: UIStackView = .init()
    private let titleStackView: UIStackView = .init()
    
    private let previewButton: DSDefaultCTAButton = .init(style: .init(type: .secondary, size: .large))
    private let saveButton: DSDefaultCTAButton = .init(style: .init(type: .primary, size: .large))
    private let bottomButtonContainer: UIStackView = .init()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


private extension MissionConditionSettingPage {
    
    func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray800
        
        
        // navBar
        navBar.action = { [unowned self] action in
            switch action {
            case .exitButtonTapped:
                pageAction?(.exitButtonTapped)
            case .prevButtonTapped:
                pageAction?(.prevButtonTapped)
            }
        }
        addSubview(navBar)
        
        
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
        
        
        // previewButton
        previewButton.do {
            $0.update(title: "미리보기")
            $0.buttonAction = { [unowned self] in
                pageAction?(.previewButtonIsTapped)
            }
            bottomButtonContainer.addArrangedSubview($0)
        }
        
        
        // saveButton
        saveButton.do {
            $0.update(title: "미션 저장")
            $0.buttonAction = { [unowned self] in
                pageAction?(.saveButtonIsTapped)
            }
            bottomButtonContainer.addArrangedSubview($0)
        }
        
        
        // bottomButtonContainer
        bottomButtonContainer.axis = .horizontal
        bottomButtonContainer.spacing = 10
        addSubview(bottomButtonContainer)
    }
    
    func setupLayout() {
        
        // navBar
        navBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.horizontalEdges.equalToSuperview()
        }
        
        
        // missionThumbnailContainer
        missionThumbnailContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(navBar.snp.bottom).offset(24)
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
            $0.horizontalEdges.equalTo(buttonStackView)
        }
        
        
        // previewButton
        previewButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35)
        }
        
        
        // bottomButtonContainer
        bottomButtonContainer.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom).offset(74)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(12)
        }
    }
    
    @objc func buttonSelected(button: MissionOptionButton) {
        guard let buttonIndex = optionButtons.firstIndex(where: { $0 == button }) else { return }
        pageAction?(.conditionButtonIsTapped(index: buttonIndex))
    }
    
    func selectOption(_ index: Int) {
        [option1Button, option2Button, option3Button, option4Button, option5Button].forEach {
            $0.isEnabled = true
            $0.isSelected = false
        }
        lineView.backgroundColor = R.Color.gray600
        switch index {
        case 0:
            option1Button.isSelected = true
        case 1:
            option2Button.isSelected = true
        case 2:
            option3Button.isSelected = true
        case 3:
            option4Button.isSelected = true
        case 4:
            option5Button.isSelected = true
        default:
            break
        }
    }
}


extension MissionConditionSettingPage {
    
    enum Update {
        case changeMissionItem(item: MissionItemRenderObject)
        case selectCondition(index: Int)
    }
    
    func update(_ update: Update) {
        switch update {
        case .changeMissionItem(let item):
            
            // Lottie animation
            if missionThumbnailView.isAnimationPlaying {
                missionThumbnailView.stop()
            }
            
            let lottieAnimation = LottieAnimation.filepath(item.guideLottiePath)
            missionThumbnailView.animation = lottieAnimation
            missionThumbnailView.play()
            
            
            // Title
            navBar.update(title: item.title)
            
            
            // Condition options
            optionLabels.enumerated().forEach { index, label in
                
                let conditionItem = item.conditionItems[index]
                label.displayText = conditionItem.title.displayText(font: .body1Medium, color: R.Color.gray50)
            }
        case .selectCondition(let index):
            selectOption(index)
        }
    }
}

#Preview(traits: .defaultLayout, body: {
    let page = MissionConditionSettingPage()
    page.update(.changeMissionItem(item: .shake))
    page.update(.selectCondition(index: 14))
    return page
})
