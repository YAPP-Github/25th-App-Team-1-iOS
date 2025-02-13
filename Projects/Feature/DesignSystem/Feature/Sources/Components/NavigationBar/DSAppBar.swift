//
//  DSAppBar.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureResources

public final class DSAppBar: UIView {
    // Sub views
    private let titleLabel: UILabel = .init()
    private let containerStack: UIStackView = .init()
    
    
    public override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 56)
    }
    
    
    public init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Public interface
public extension DSAppBar {
    @discardableResult
    func update(titleText: String) -> Self {
        titleLabel.displayText = titleText.displayText(
            font: .body1SemiBold,
            color: R.Color.white100
        )
        return self
    }
    
    @discardableResult
    func insertLeftView(_ view: UIView) -> Self {
        containerStack.insertArrangedSubview(view, at: 0)
        return self
    }
    
    @discardableResult
    func insertRightView(_ view: UIView) -> Self {
        containerStack.addArrangedSubview(view)
        return self
    }
}


// MARK: Setup
private extension DSAppBar {
    func setupUI() {
        // containerStack
        containerStack.axis = .horizontal
        containerStack.alignment = .center
        [UIView(), titleLabel, UIView()].forEach {
            containerStack.addArrangedSubview($0)
        }
        addSubview(containerStack)
    }
    
    func setupLayout() {
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        
        // containerStack
        containerStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
