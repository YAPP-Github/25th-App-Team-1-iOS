//
//  AddMissionPage.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/31/25.
//

import UIKit

import FeatureResources
import FeatureUIDependencies

final class AddMissionPage: UIView {
    
    // Action
    enum Action {
        case addNewMissionButtonTapped
    }
    var pageAction: ((Action) -> ())?
    
    
    // UI
    private let headTitleLabel: UILabel = .init()
    private let contentsView: UIView = .init()
    
    private let addMissionContainer: UIView = .init()
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
}

private extension AddMissionPage {
    
    func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray800
        
        
        // titleLabel
        headTitleLabel.displayText = "미션".displayText(font: .heading2SemiBold, color: R.Color.white100)
        addSubview(headTitleLabel)
        
        
        // contentsView
        addSubview(contentsView)
        
        
        // addMissionContainerView
        contentsView.addSubview(addMissionContainer)
        
        
        // contentsStackView
        contentsStackView.alignment = .center
        contentsStackView.axis = .vertical
        contentsStackView.spacing = 32
        addMissionContainer.addSubview(contentsStackView)
        
        
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
            pageAction?(.addNewMissionButtonTapped)
        }
    }
    
    func setupLayout() {
        
        // titleLabel
        headTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.left.equalToSuperview().inset(24)
        }
        
        
        // contentsView
        contentsView.snp.makeConstraints { make in
            make.top.equalTo(headTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        // addMissionContainerView
        addMissionContainer.snp.makeConstraints { make in
            make.height.equalTo(446)
            make.top.equalToSuperview().inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(36)
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


#Preview(traits: .defaultLayout, body: {
    AddMissionPage()
})
