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
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if bounds.contains(touch.location(in: self)) {
            action?(.itemIsTapped)
        }
    }
    
    
    private func setupUI() {
        // self
        self.backgroundColor = R.Color.gray800
        
        
        // itemImage
        itemImage.contentMode = .scaleAspectFit
        contentStack.addArrangedSubview(itemImage)
        
        
        // titleLabel
        contentStack.addArrangedSubview(titleLabel)
        
        
        // stack
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.distribution = .fill
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
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(16)
        }
    }
    
    
    enum Update {
        case image(UIImage)
        case title(String)
    }
    
    func update(_ update: Update) {
        switch update {
        case .image(let image):
            itemImage.image = image
        case .title(let str):
            titleLabel.displayText = str.displayText(font: .heading2SemiBold, color: R.Color.white100)
        }
    }
}
