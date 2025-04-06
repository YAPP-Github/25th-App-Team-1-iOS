//
//  DSRightImageButton.swift
//  DesignSystem
//
//  Created by choijunios on 2/3/25.
//

import UIKit

import FeatureResources

public final class DSRightImageButton: TouchDetectingView {
    
    // State
    private var isPressing: Bool = false
    
    
    // Sub view
    private let backgroundLayer = CALayer()
    private let titleLabel: UILabel = .init()
    private let imageView: UIImageView = .init()
    private let contentStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    
    // button action
    public var buttonAction: (() -> Void)?
    
    
    public override var intrinsicContentSize: CGSize {
        .init(
            width: UIView.noIntrinsicMetric,
            height: 42
        )
    }
    
    
    public init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if isPressing {
            let size = CGSize(
                width: self.layer.bounds.size.width-4,
                height: self.layer.bounds.size.height-4
            )
            let point = CGPoint(x: 2, y: 2)
            backgroundLayer.frame = .init(
                origin: point,
                size: size
            )
        } else {
            backgroundLayer.frame = self.layer.bounds
        }
        CATransaction.commit()
    }
    
    
    private func setupUI() {
        // self
        self.backgroundColor = .clear
        
        
        // backgroundLayer
        backgroundLayer.backgroundColor = R.Color.gray700.cgColor
        backgroundLayer.cornerRadius = 12
        self.layer.addSublayer(backgroundLayer)
        
        
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
        // Pressing
        self.isPressing = true
        setNeedsLayout()
        
        self.backgroundLayer.backgroundColor = R.Color.gray600.cgColor
        titleLabel.displayText = titleLabel.displayText?.string.displayText(
            font: .body2Medium,
            color: R.Color.white80
        )
        imageView.tintColor = R.Color.white80
    }
    public override func onTouchOut(isInbound: Bool?) {
        // Pressing
        self.isPressing = false
        setNeedsLayout()
        
        self.backgroundLayer.backgroundColor = R.Color.gray700.cgColor
        titleLabel.displayText = titleLabel.displayText?.string.displayText(
            font: .body1SemiBold,
            color: R.Color.white100
        )
        imageView.tintColor = R.Color.white100
    }
    public override func onTap(direction: TouchDetectingView.TapDirection) { buttonAction?() }
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
