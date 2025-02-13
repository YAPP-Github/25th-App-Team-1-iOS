//
//  DSSharedListItemView.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureResources

public final class DSSharedListItemView: TouchDetectingView {
    // Sub views
    private let iconImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let moveImageView: UIImageView = .init()
    private let contentStack: UIStackView = .init()
    
    
    // Tap action
    public var tapAction: (() -> Void)?
    
    
    public init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    public override func onTouchOut() {
        tapAction?()
    }
}


// MARK: Public interface
public extension DSSharedListItemView {
    @discardableResult
    func update(titleText: String) -> Self {
        titleLabel.displayText = titleText.displayText(
            font: .body1Medium,
            color: R.Color.white100
        )
        return self
    }
    
    @discardableResult
    func update(image: UIImage?) -> Self {
        iconImageView.image = image
        iconImageView.isHidden = image == nil
        return self
    }
}


// MARK: Setup
private extension DSSharedListItemView {
    func setupUI() {
        // self
        self.backgroundColor = .clear
        
        
        // iconImageView
        iconImageView.isHidden = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = R.Color.white100
        
        
        // moveImageView
        moveImageView.contentMode = .scaleAspectFit
        moveImageView.image = FeatureResourcesAsset.gnbRight.image
        moveImageView.tintColor = R.Color.gray300
        
        
        // contentStack
        contentStack.axis = .horizontal
        contentStack.spacing = 10
        contentStack.alignment = .center
        contentStack.distribution = .fill
        contentStack.backgroundColor = .clear
        [iconImageView, titleLabel, UIView(), moveImageView].forEach {
            contentStack.addArrangedSubview($0)
        }
        addSubview(contentStack)
    }
    
    func setupLayout() {
        // moveImageView
        moveImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
        }
        
        
        // iconImageView
        iconImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        
        
        // contentStack
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
