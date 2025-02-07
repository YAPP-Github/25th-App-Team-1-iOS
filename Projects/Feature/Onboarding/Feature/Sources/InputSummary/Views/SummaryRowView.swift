//
//  SummaryRowView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import UIKit

import FeatureUIDependencies

import FeatureThirdPartyDependencies

final class SummaryRowView: UIView {
    
    // Sub views
    private let keyLabel: UILabel = .init()
    private let valueLabel: UILabel = .init()
    private let labelStack: UIStackView = .init()
    
    
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 50)
    }
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Public interface
extension SummaryRowView {
    
    @discardableResult
    func update(keyText: String) -> Self {
        keyLabel.displayText = keyText.displayText(
            font: .body1Regular, color: R.Color.gray50
        )
        return self
    }
    
    
    @discardableResult
    func update(valueText: String) -> Self {
        valueLabel.displayText = valueText.displayText(
            font: .body1SemiBold, color: R.Color.gray50
        )
        return self
    }
}


// MARK: Set up
private extension SummaryRowView {
    
    func setupUI() {
        
        // self
        self.backgroundColor = .clear
        
        // labelStack
        [keyLabel,UIView(),valueLabel].forEach({labelStack.addArrangedSubview($0)})
        labelStack.axis = .horizontal
        labelStack.distribution = .fill
        labelStack.alignment = .fill
        addSubview(labelStack)
    }
    
    
    func setupLayout() {
        
        // labelStack
        labelStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
    }
}

#Preview {
    
    SummaryRowView()
        .update(keyText: "성명")
        .update(valueText: "홍길동")
}
