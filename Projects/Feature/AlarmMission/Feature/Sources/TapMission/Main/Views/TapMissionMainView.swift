//
//  TapMissionMainView.swift
//  AlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import FeatureUIDependencies
import FeatureThirdPartyDependencies

protocol TapMissionMainViewListener: AnyObject {
    func action(_ action: TapMissionMainView.Action)
}

final class TapMissionMainView: UIView {
    // Listener
    weak var listener: TapMissionMainViewListener?
    
    
    // Sub views
    private let tagLabelView: TagLabelView = .init().then {$0.update(text: "기상미션")}
    private let titleLabelStack: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    private let subTitleLabel: UILabel = .init().then {
        $0.displayText = "10회를 눌러서".displayText(font: .headline2Medium, color: .white)
    }
    private let titleLabel: UILabel = .init().then {
        $0.displayText = "편지를 열어줘".displayText(font: .title2Bold, color: .white)
    }
    private let letterImage: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.tapMissionMainLetter.image
        $0.contentMode = .scaleAspectFit
    }
    
    // - Buttons
    private let startMissionButton: DSDefaultCTAButton = .init(
        initialState: .active, style: .init(
            type: .primary,
            size: .large,
            cornerRadius: .medium)
    )
    private let rejectMissionButton: DSLabelButton = .init(config: .init(
        font: .body1SemiBold,
        textColor: .white)
    )
    
    // - Background
    private let backgroundView = MissionMainBackgroundView()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Public interface
extension TapMissionMainView {
    enum Action {
        case startMissionButtonClicked
        case rejectMissionButtonClicked
    }
}


// MARK: Setup
private extension TapMissionMainView {
    func setupUI() {
        // backgroundView
        addSubview(backgroundView)
        
        
        // tagLabel
        addSubview(tagLabelView)
        
        
        // titleLabels
        [subTitleLabel, titleLabel].forEach({ titleLabelStack.addArrangedSubview($0) })
        addSubview(titleLabelStack)
        
        
        // letterImage
        addSubview(letterImage)
        
        
        // startMissionButton
        startMissionButton.update(title: "미션 시작")
        startMissionButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.startMissionButtonClicked)
        }
        addSubview(startMissionButton)
        
        
        // rejectMissionButton
        rejectMissionButton.update(titleText: "미션하지 않기")
        rejectMissionButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.rejectMissionButtonClicked)
        }
        addSubview(rejectMissionButton)
    }
    
    func setupLayout() {
        // backgroundView
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        // tagLabel
        tagLabelView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).offset(49)
        }
        
        
        // titleLabels
        titleLabelStack.snp.makeConstraints { make in
            make.top.equalTo(tagLabelView.snp.bottom).offset(34)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        
        // letterImage
        letterImage.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(titleLabelStack.snp.bottom).offset(19)
            make.left.greaterThanOrEqualTo(self.safeAreaInsets)
            make.right.lessThanOrEqualTo(self.safeAreaInsets)
            make.bottom.lessThanOrEqualTo(startMissionButton.snp.top).offset(-31)
        }
        
        
        // startMissionButton
        startMissionButton.setContentCompressionResistancePriority(.required, for: .vertical)
        startMissionButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaInsets).inset(20)
            make.bottom.equalTo(rejectMissionButton.snp.top).offset(-22)
        }
        
        
        // rejectMissionButton
        rejectMissionButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-26)
            make.centerX.equalToSuperview()
        }
    }
}


#Preview {
    TapMissionMainView()
}
