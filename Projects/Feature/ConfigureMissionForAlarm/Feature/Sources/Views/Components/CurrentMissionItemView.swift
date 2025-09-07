//
//  DiscardableMissionItemView.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/30/25.
//

import UIKit

import FeatureUIDependencies

final class CurrentMissionItemView: UIView {
    
    // Action
    enum Action {
        case tapped
        case discardButtonTapped
    }
    var action: ((Action) -> ())?
    
    
    // UI
    private let iconImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let missionCountButton: MissionCountView = .init()
    private let missionDescriptionContainer: UIStackView = .init()
    private let trashButton: DSDefaultIconButton = .init(style: .init(
        type: .default,
        image: FeatureResourcesAsset.trashStroke.image,
        size: .custom(
            size: .init(width: 20, height: 20),
            inset: 0
        )
    ))
    private let mainContainer: UIStackView = .init()
    
    
    override var intrinsicContentSize: CGSize {
        .init(
            width: UIView.noIntrinsicMetric,
            height: 52
        )
    }
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private var initialTouch: UITouch?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            initialTouch = touch
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentLocation = touch.location(in: self)
            
            guard bounds.contains(currentLocation) == true else { return }
            
            action?(.tapped)
        }
    }
}


private extension CurrentMissionItemView {
    
    func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray800
        
        
        // iconImageView
        missionDescriptionContainer.addArrangedSubview(iconImageView)
        
        
        // labelStack
        let labelStack: UIStackView = .init(arrangedSubviews: [
            titleLabel,
            missionCountButton,
            UIView()
        ])
        labelStack.axis = .horizontal
        labelStack.spacing = 8
        labelStack.distribution = .fill
        labelStack.alignment = .center
        missionDescriptionContainer.addArrangedSubview(labelStack)
        
        
        // missionDescriptionContainerView
        let missionDescriptionContainerView: UIView = .init()
        mainContainer.addArrangedSubview(missionDescriptionContainerView)
        
        
        // missionDescriptionContainer
        missionDescriptionContainer.axis = .horizontal
        missionDescriptionContainer.spacing = 12
        missionDescriptionContainerView.addSubview(missionDescriptionContainer)
        
        
        // iconBaseView
        let iconBaseView: UIView = .init()
        mainContainer.addArrangedSubview(iconBaseView)
        
        
        // trashButton
        trashButton.buttonAction = { [unowned self] in
            action?(.discardButtonTapped)
        }
        iconBaseView.addSubview(trashButton)
        
        
        // mainContainer
        mainContainer.axis = .horizontal
        mainContainer.spacing = 0
        addSubview(mainContainer)
    }
    
    
    func setupLayout() {
        
        // mainContainer
        mainContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        // iconImageView
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
        
        
        // missionDescriptionContainer
        missionDescriptionContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        
        // trashButton
        trashButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}


extension CurrentMissionItemView {
    func update(mission: MissionItemRenderObject) {
        
        // iconImageView
        iconImageView.image = mission.iconImage
        
        // titleLabel
        titleLabel.displayText = mission.title.displayText(font: .headline2SemiBold, color: R.Color.white100)
    }
    
    func update(countText: String) {
        missionCountButton.update(title: countText)
    }
}


#Preview(traits: .defaultLayout, body: {
    let view = CurrentMissionItemView()
    view.update(mission: .shake)
    view.update(countText: "15회")
    return view
})
