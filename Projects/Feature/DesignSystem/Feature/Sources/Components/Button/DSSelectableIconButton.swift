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
    public var buttonAction: ((ButtonState) -> Void)?
    
    
    // State & style
    private var state: ButtonState
    private let style: ButtonStyle
    
    
    // Content size
    public override var intrinsicContentSize: CGSize {
        style.size.buttonSize
    }
    
    public init(
        initialState state: ButtonState,
        style: ButtonStyle
    ) {
        self.state = state
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
    
    public override func onTouchIn() {
        apply(state: .pressed)
    }
    
    
    public override func onTouchOut() {
        let state: ButtonState = state == .idle ? .selected : .idle
        self.state = state
        apply(state: state)
        buttonAction?(state)
    }
    
    private func apply(state: ButtonState) {
        self.backgroundColor = state.backgroundColor
        self.imageView.tintColor = state.imageTintColor
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
        self.state = state
        apply(state: state)
        return self
    }
}


// MARK: Setup
private extension DSSelectableIconButton {
    func setupUI() {
        // self
        self.backgroundColor = state.backgroundColor
        
        // imageView
        imageView.image = style.image
        imageView.tintColor = state.imageTintColor
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
