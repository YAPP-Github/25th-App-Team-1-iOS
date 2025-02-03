//
//  DSRightImageButton.swift
//  DesignSystem
//
//  Created by choijunios on 2/3/25.
//

import UIKit

import FeatureResources

public final class DSRightImageButton: TouchDetectingView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private let imageView: UIImageView = .init()
    private let contentStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    
    // button action
    public var buttonAction: (() -> Void)?
    
    
    public init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        // self
        self.backgroundColor = R.Color.gray700
        self.layer.cornerRadius = 12
        
        
        // imageView
        imageView.tintColor = R.Color.white100
        imageView.contentMode = .scaleAspectFit
        
        
        // contentStack
        [titleLabel, UIView(), imageView].forEach {
            contentStack.addArrangedSubview($0)
        }
        addSubview(contentStack)
    }
    
    private func setupLayout() {
        // self
        self.snp.makeConstraints { make in
            make.width.equalTo(120).priority(.high)
        }
        
        
        // imageView
        imageView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        
        // contentStack
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(14)
            make.verticalEdges.equalToSuperview().inset(8)
        }
    }
    
    public override func onTouchIn() {
        self.backgroundColor = R.Color.gray600
        titleLabel.displayText = titleLabel.displayText?.string.displayText(
            font: .body1SemiBold,
            color: R.Color.white80
        )
        imageView.tintColor = R.Color.white80
    }
    public override func onTouchOut() {
        self.backgroundColor = R.Color.gray700
        titleLabel.displayText = titleLabel.displayText?.string.displayText(
            font: .body1SemiBold,
            color: R.Color.white100
        )
        imageView.tintColor = R.Color.white100
        
        // Action
        buttonAction?()
    }
}


// MARK: Public interface
public extension DSRightImageButton {
    @discardableResult
    func update(titleText: String) -> Self {
        titleLabel.displayText = titleText.displayText(
            font: .body1SemiBold,
            color: R.Color.white100
        )
        return self
    }
    
    @discardableResult
    func update(image: UIImage?) -> Self {
        imageView.image = image
        return self
    }
}


#Preview {
    DSRightImageButton()
        .update(titleText: "테스트")
        .update(image: FeatureResourcesAsset.holiday.image)
}
