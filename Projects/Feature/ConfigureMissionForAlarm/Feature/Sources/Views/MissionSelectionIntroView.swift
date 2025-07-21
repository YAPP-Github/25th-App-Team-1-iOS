//
//  MissionSelectionIntroView.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import UIKit

import FeatureUIDependencies

enum MissionSelectionIntroViewAction {
    case addNewMission
}

protocol MissionSelectionIntroViewListener: AnyObject {
    func request(_ action: MissionSelectionIntroViewAction)
}

final class MissionSelectionIntroView: UIView {
    
    // Listener
    weak var listener: MissionSelectionIntroViewListener?
    
    
    // UI
    private let headTitleLabel: UILabel = .init()
    private let contentsBaseView: UIView = .init()
    private let contentsStackView: UIStackView = .init()
    private let titleLabelStack: UIStackView = .init()
    private let titleLabel: UILabel = .init()
    private let subtitleLabel: UILabel = .init()
    private let addMissionButton: DSDefaultCTAButton = .init(
        style: .init(
            type: .tertiary,
            size: .medium,
            cornerRadius: .large
        )
    )
    
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func draw(_ rect: CGRect) {
        
        let radius: CGFloat = 24.0

        // 라운딩할 모서리 지정 (상단 좌우만)
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        // 클리핑과 색상 채우기
        R.Color.gray800.setFill()
        path.fill()
    }
}


// MARK: Setup
private extension MissionSelectionIntroView {
    func setupUI() {
        
        // self
        isOpaque = false
        
        
        // titleLabel
        headTitleLabel.displayText = "미션 선택".displayText(font: .heading2SemiBold, color: R.Color.white100)
        addSubview(headTitleLabel)
        
        
        // contentView
        addSubview(contentsBaseView)
        
        
        // contentsStackView
        contentsStackView.alignment = .center
        contentsStackView.axis = .vertical
        contentsStackView.spacing = 32
        contentsBaseView.addSubview(contentsStackView)
        
        
        // titleLabelStack
        titleLabelStack.axis = .vertical
        titleLabelStack.alignment = .center
        titleLabelStack.spacing = 6
        contentsStackView.addArrangedSubview(titleLabelStack)
        
        
        // titleLabels
        titleLabel.displayText = "등록된 미션이 없어요".displayText(font: .body1Bold, color: R.Color.white100)
        titleLabelStack.addArrangedSubview(titleLabel)
        subtitleLabel.displayText = "새 미션을 추가해보세요".displayText(font: .label2regular, color: R.Color.white80)
        titleLabelStack.addArrangedSubview(subtitleLabel)
        
        
        // addMissionButton
        addMissionButton.update(leftImage: FeatureResourcesAsset.plus.image)
        addMissionButton.update(title: "미션추가")
        contentsStackView.addArrangedSubview(addMissionButton)
        addMissionButton.buttonAction = { [unowned self] in
            listener?.request(.addNewMission)
        }
    }
    
    func setupLayout() {
        
        // titleLabel
        headTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.left.equalToSuperview().inset(24)
        }
        
        
        // contentsBaseView
        contentsBaseView.snp.makeConstraints { make in
            make.top.equalTo(headTitleLabel).offset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(36)
        }
        
        
        // contentsStackView
        contentsStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
        // addMissionButton
        addMissionButton.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(127)
        }
    }
}
