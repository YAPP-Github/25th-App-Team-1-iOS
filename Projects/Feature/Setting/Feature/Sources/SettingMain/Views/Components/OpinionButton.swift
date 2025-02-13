//
//  OpinionButton.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies
import FeatureCommonDependencies

final class OpinionButton: TouchDetectingView {
    // Sub views
    private let titleLabel: UILabel = .init()
    private let moveImageView: UIImageView = .init()
    private let containerStack: UIStackView = .init()
    
    
    // Action
    var buttonAction: (() -> Void)?
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func onTouchOut() {
        buttonAction?()
    }
}


private extension OpinionButton {
    func setupUI() {
        // self
        self.backgroundColor = .clear
        
        
        // titleLabel
        titleLabel.displayText = "의견 보내기".displayText(
            font: .label1Medium,
            color: R.Color.main100
        )
        
        
        // moveImageView
        moveImageView.image = FeatureResourcesAsset.chevronRight.image
        moveImageView.tintColor = R.Color.main100
        moveImageView.contentMode = .scaleAspectFit
        
        
        // containerStack
        containerStack.axis = .horizontal
        containerStack.alignment = .center
        [titleLabel, moveImageView].forEach {
            containerStack.addArrangedSubview($0)
        }
        addSubview(containerStack)
    }
    
    func setupLayout() {
        // moveImageView
        moveImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        
        // containerStack
        containerStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(4)
        }
    }
}

#Preview {
    OpinionButton()
}
