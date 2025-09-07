//
//  MissionItemView.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/22/25.
//

import UIKit

import FeatureResources
import FeatureDesignSystem

final class MissionItemView: TouchDetectingView {
    
    // Action
    enum Action {
        case itemIsTapped
    }
    
    
    // Listener
    var action: ((Action) -> Void)?
    
    
    // UI
    private let itemImage: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let contentStack: UIStackView = .init()
    
    private let selectedContainer: UIStackView = .init()
    private let selectedLabel: UILabel = .init()
    private let checkImage: UIImageView = .init()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func onTap(direction: TouchDetectingView.TapDirection) {
        action?(.itemIsTapped)
    }
    
    
    private func setupUI() {
        // self
        self.backgroundColor = R.Color.gray800
        
        
        // itemImage
        itemImage.contentMode = .scaleAspectFit
        contentStack.addArrangedSubview(itemImage)
        
        
        // titleLabel
        contentStack.addArrangedSubview(titleLabel)
        
        
        // checkImage
        checkImage.image = FeatureResourcesAsset.check.image
        checkImage.tintColor = R.Color.white40
        selectedContainer.addArrangedSubview(checkImage)
        
        
        // selectedLabel
        selectedLabel.displayText = "선택됨".displayText(font: .body2Medium, color: R.Color.white40)
        selectedContainer.addArrangedSubview(selectedLabel)
        
        
        // selectedContainer
        selectedContainer.axis = .horizontal
        selectedContainer.spacing = 2
        selectedContainer.alignment = .center
        contentStack.addArrangedSubview(UIView())
        contentStack.addArrangedSubview(selectedContainer)
        
        // stack
        contentStack.axis = .horizontal
        contentStack.distribution = .fill
        contentStack.alignment = .center
        contentStack.spacing = 12
        addSubview(contentStack)
    }
    
    private func setupLayout() {
        
        // itemImage
        itemImage.snp.makeConstraints { make in
            make.width.height.equalTo(28)
        }
        
        
        // contentStack
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(16)
        }
    }
    
    
    enum Update {
        case image(UIImage)
        case title(String)
        case setSelectionTag(isHidden: Bool)
    }
    
    func update(_ update: Update) {
        switch update {
        case .image(let image):
            itemImage.image = image
        case .title(let str):
            titleLabel.displayText = str.displayText(font: .headline2SemiBold, color: R.Color.white100)
        case .setSelectionTag(let isHidden):
            selectedContainer.isHidden = isHidden
        }
    }
}
