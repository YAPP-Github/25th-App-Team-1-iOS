//
//  CurrentMissionPage.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/31/25.
//

import UIKit

import FeatureResources
import FeatureUIDependencies

final class CurrentMissionPage: UIView {
    
    // Action
    enum Action {
        case currentMissionItemTapped
        case deleteMissionButtonTapped
        
        case changeMissionButtonTapped
        case completeButtonTapped
    }
    var pageAction: ((Action) -> ())?
    
    // UI
    private let headTitleLabel: UILabel = .init()
    private let contentsView: UIView = .init()
    
    private let currentMissionContainer: UIView = .init()
    private let currentMissionItemView: CurrentMissionItemView = .init()
    
    private let bottomButtonContainer: UIStackView = .init()
    private let missionChangeButton: DSDefaultCTAButton = .init(
        style: .init(
            type: .secondary,
            size: .large
        )
    )
    private let completeButton: DSDefaultCTAButton = .init(
        style: .init(
            type: .primary,
            size: .large
        )
    )
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


private extension CurrentMissionPage {
    func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray800

        
        // titleLabel
        headTitleLabel.displayText = "미션".displayText(font: .heading2SemiBold, color: R.Color.white100)
        addSubview(headTitleLabel)
        
        
        // contentsView
        addSubview(contentsView)
        
        
        // currentMissionContainer
        contentsView.addSubview(currentMissionContainer)
        
        
        // currentMissionItemView
        currentMissionContainer.addSubview(currentMissionItemView)
        currentMissionItemView.action = { [unowned self] action in
            switch action {
            case .discardButtonTapped:
                pageAction?(.deleteMissionButtonTapped)
            case .tapped:
                pageAction?(.currentMissionItemTapped)
            }
        }
       
        
        // bottomButtonContainer
        bottomButtonContainer.do {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        currentMissionContainer.addSubview(bottomButtonContainer)
        
        
        // missionChangeButton
        missionChangeButton.do {
            $0.update(title: "미션변경")
            $0.buttonAction = { [unowned self] in
                pageAction?(.changeMissionButtonTapped)
            }
        }
        bottomButtonContainer.addArrangedSubview(missionChangeButton)
        
        // confirmButton
        completeButton.do {
            $0.update(title: "완료")
            $0.buttonAction = { [unowned self] in
                pageAction?(.completeButtonTapped)
            }
        }
        bottomButtonContainer.addArrangedSubview(completeButton)
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
        
        
        // currentMissionContainer
        currentMissionContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        // currentMissionItemView
        currentMissionItemView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(6)
        }
        
        
        // bottomButtonContainer
        bottomButtonContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(currentMissionItemView.snp.bottom).offset(32)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(12)
        }
    }
}


extension CurrentMissionPage {
    func update(item: MissionItemRenderObject, conditionIndex: Int) {
        currentMissionItemView.update(mission: item)
        currentMissionItemView.update(countText: "\(conditionIndex)회")
    }
}


#Preview(traits: .defaultLayout, body: {
    let page = CurrentMissionPage()
    page.update(item: .shake, conditionIndex: 5)
    return page
})
