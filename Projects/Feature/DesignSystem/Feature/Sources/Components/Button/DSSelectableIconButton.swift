//
//  DSSelectableIconButton.swift
//  DesignSystem
//
//  Created by choijunios on 2/3/25.
//

import UIKit

import FeatureResources

import SnapKit

final public class DSSelectableIconButton: TouchDetectingView {
    
    // Sub
    private let imageView: UIImageView = .init()
    
    
    // Button action
    public var buttonAction: (() -> Void)?
    
    
    // State & style
    private let initialState: ButtonState
    private let style: ButtonStyle
    
    
    // Content size
    public override var intrinsicContentSize: CGSize {
        style.size.buttonSize
    }
    
    public init(initialState: ButtonState = .idle, style: ButtonStyle) {
        self.initialState = initialState
        self.style = style
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.layer.bounds.height/2
    }
    
    public override func onTap() {
        super.onTap()
        buttonAction?()
    }
}


// MARK: Public interface
public extension DSSelectableIconButton {
    @discardableResult
    func update(image: UIImage) -> Self {
        self.imageView.image = image
        return self
    }
    
    @discardableResult
    func update(state: ButtonState) -> Self {
        apply(state: state)
        return self
    }
    
    private func apply(state: ButtonState) {
        self.backgroundColor = state.backgroundColor
        self.imageView.tintColor = state.imageTintColor
    }
}


// MARK: Setup
private extension DSSelectableIconButton {
    func setupUI() {
        // self
        self.backgroundColor = initialState.backgroundColor
        
        // imageView
        imageView.image = style.image
        imageView.tintColor = initialState.imageTintColor
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
    
    
    func setupLayout() {
        // imageView
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
                .inset(style.size.imageInset)
        }
    }
}


// MARK: Configuration
extension DSSelectableIconButton {
    
    public struct ButtonStyle {
        public let image: UIImage
        public let size: ButtonSize
        
        public init(image: UIImage, size: ButtonSize) {
            self.image = image
            self.size = size
        }
    }
    
    
    public enum ButtonState {
        case idle
        case pressed
        case selected
        
        var backgroundColor: UIColor {
            switch self {
            case .idle:
                .clear
            case .pressed:
                .clear
            case .selected:
                R.Color.gray800
            }
        }
        
        var imageTintColor: UIColor {
            switch self {
            case .idle:
                R.Color.white100
            case .pressed:
                R.Color.white80
            case .selected:
                R.Color.white80
            }
        }
    }
    
    
    public enum ButtonSize {
        case small
        case medium
        case large
        
        var buttonSize: CGSize {
            switch self {
            case .small:
                .init(width: 32, height: 32)
            case .medium:
                .init(width: 32, height: 32)
            case .large:
                .init(width: 36, height: 36)
            }
        }
        
        var imageInset: CGFloat {
            switch self {
            case .small:
                return 4.0
            case .medium:
                return 0.0
            case .large:
                return 6.0
            }
        }
    }
}


#Preview {
    DSSelectableIconButton(
        initialState: .idle,
        style: .init(
            image: FeatureResourcesAsset.more.image,
            size: .small
        )
    )
}
