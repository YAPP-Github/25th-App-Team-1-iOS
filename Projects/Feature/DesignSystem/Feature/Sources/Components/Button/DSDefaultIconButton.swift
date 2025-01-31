//
//  DSDefaultIconButton.swift
//  DesignSystem
//
//  Created by choijunios on 1/31/25.
//

import UIKit

import FeatureResources

import SnapKit

final public class DSDefaultIconButton: TouchDetectingView {
    
    // Sub
    private let imageView: UIImageView = .init()
    
    
    // Button action
    public var buttonAction: (() -> Void)?
    
    
    // State & style
    private let style: ButtonStyle
    
    
    // Content size
    public override var intrinsicContentSize: CGSize {
        style.size.buttonSize
    }
    
    public init(
        style: ButtonStyle
    ) {
        self.style = style
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func onTouchIn() {
        self.imageView.tintColor = style.type.pressedImageTintColor
    }
    
    
    public override func onTouchOut() {
        self.imageView.tintColor = style.type.defaultImageTintColor
        buttonAction?()
    }
}


// MARK: Setup
private extension DSDefaultIconButton {
    func setupUI() {
        // self
        self.backgroundColor = .clear
        
        // imageView
        imageView.image = style.image
        imageView.tintColor = style.type.defaultImageTintColor
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
extension DSDefaultIconButton {
    
    public struct ButtonStyle {
        public let type: ButtonType
        public let image: UIImage
        public let size: ButtonSize
        
        public init(type: ButtonType, image: UIImage, size: ButtonSize) {
            self.type = type
            self.image = image
            self.size = size
        }
    }
    
    
    public enum ButtonType {
        case `default`
        
        var defaultImageTintColor: UIColor {
            switch self {
            case .default:
                R.Color.white100
            }
        }
        
        var pressedImageTintColor: UIColor {
            switch self {
            case .default:
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
    let view = DSDefaultIconButton(style: .init(
        type: .default,
        image: FeatureResourcesAsset.plus.image,
        size: .medium
    ))
    view.buttonAction = {
        print("button action")
    }
    return view
}
