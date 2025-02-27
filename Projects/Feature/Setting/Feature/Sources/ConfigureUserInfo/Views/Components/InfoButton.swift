//
//  InfoButton.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies

final class InfoButton: TouchDetectingView {
    // Sub view
    private let infoLabel: UILabel = .init()
    private let containerStack: UIStackView = .init()
    
    
    // Button action
    var buttonAction: (() -> Void)?
    
    
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 52)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }

    override func onTouchOut(isInbound: Bool?) {
        buttonAction?()
    }
}


// MARK: Public interface
extension InfoButton {
    @discardableResult
    func update(text: String) -> Self {
        self.infoLabel.displayText = text.displayText(
            font: .body1Regular,
            color: R.Color.gray50
        )
        return self
    }
}


// MARK: Setup
private extension InfoButton {
    func setupUI() {
        // self
        self.backgroundColor = R.Color.gray800
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = R.Color.gray700.cgColor
        
        
        // containerStack
        containerStack.axis = .horizontal
        containerStack.alignment = .center
        containerStack.distribution = .fill
        [infoLabel, UIView()].forEach {
            containerStack.addArrangedSubview($0)
        }
        addSubview(containerStack)
    }
    
    func setupLayout() {
        // infoLabel
        containerStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
