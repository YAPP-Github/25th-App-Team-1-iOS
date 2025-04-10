//
//  ShakeMissionMainView.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureUIDependencies
import FeatureThirdPartyDependencies

protocol ShakeMissionMainViewListener: AnyObject {
    
    func action(_ action: ShakeMissionMainView.Action)
}

class ShakeMissionMainView: UIView {
    
    // Action
    enum Action {
        case startMissionButtonClicked
        case rejectMissionButtonClicked
    }
    
    
    // Listener
    weak var listener: ShakeMissionMainViewListener?
    
    
    // Sub views
    private let tagLabelView: TagLabelView = .init().then {$0.update(text: "기상미션")}
    private let titleLabelStack: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .center
    }
    private let subTitleLabel: UILabel = .init().then {
        $0.displayText = "10회를 흔들어".displayText(font: .headline2Medium, color: .white)
    }
    private let titleLabel: UILabel = .init().then {
        $0.displayText = "부적을 뒤집어줘".displayText(font: .title2Bold, color: .white)
    }
    private let amuletImage: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.shakeMissionAmulet.image
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


// MARK: Setup
private extension ShakeMissionMainView {
    
    func setupUI() {
        // backgroundView
        addSubview(backgroundView)
        
        
        // tagLabel
        addSubview(tagLabelView)
        
        
        // titleLabels
        [subTitleLabel, titleLabel].forEach({ titleLabelStack.addArrangedSubview($0) })
        addSubview(titleLabelStack)
        
        
        // amuletImage
        addSubview(amuletImage)
        
        
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
        
        
        // amuletImage
        amuletImage.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        amuletImage.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        amuletImage.snp.makeConstraints { make in
            make.top.equalTo(titleLabelStack.snp.bottom).offset(76)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualTo(self.safeAreaInsets).inset(38)
            make.right.lessThanOrEqualTo(self.safeAreaInsets).inset(38)
            make.bottom.lessThanOrEqualTo(startMissionButton.snp.top).inset(-75).priority(.low)
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
    ShakeMissionMainView()
}
