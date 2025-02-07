//
//  DSCheckBox.swift
//  DesignSystem
//
//  Created by choijunios on 2/3/25.
//

import UIKit

import FeatureResources

import SnapKit

public final class DSCheckBox: TouchDetectingView {
    
    // State
    private var state: ButtonState
    
    
    // Style
    private let buttonStyle: ButtonStyle
    
    
    // Sub view
    private let checkImage: UIImageView = .init()
    
    
    // Button action
    public var buttonAction: ((ButtonState) -> Void)?
    
    
    public override var intrinsicContentSize: CGSize {
        buttonStyle.size.buttonSize
    }
    
    
    public init(initialState state: ButtonState, buttonStyle: ButtonStyle) {
        self.state = state
        self.buttonStyle = buttonStyle
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setupUI() {
        // self
        self.layer.cornerRadius = 4
        self.backgroundColor = state.backgroundColor
        
        
        // checkImage
        checkImage.contentMode = .scaleAspectFit
        checkImage.image = FeatureResourcesAsset.check.image
        checkImage.tintColor = state.imageTintColor
        addSubview(checkImage)
    }
    
    private func setupLayout() {
        // checkImage
        checkImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    
    public override func onTouchOut() {
        let nextState: ButtonState = self.state == .idle ? .seleceted : .idle
        self.state = nextState
        apply(state: nextState)
        buttonAction?(nextState)
    }
    
    private func apply(state: ButtonState) {
        self.backgroundColor = state.backgroundColor
        checkImage.tintColor = state.imageTintColor
    }
}


// MARK: Public interface
public extension DSCheckBox {
    @discardableResult
    func update(state: ButtonState) -> Self {
        self.state = state
        apply(state: state)
        return self
    }
    
    func toggle() {
        self.state = state == .idle ? .seleceted : .idle
        apply(state: state)
    }
}


// MARK: Style
public extension DSCheckBox {
    struct ButtonStyle {
        let size: ButtonSize
        public init(size: ButtonSize) {
            self.size = size
        }
    }
    
    enum ButtonSize {
        case medium, small
        
        var buttonSize: CGSize {
            switch self {
            case .medium:
                .init(width: 20, height: 20)
            case .small:
                .init(width: 16, height: 16)
            }
        }
    }
    
    enum ButtonState {
        case idle
        case seleceted
        
        var backgroundColor: UIColor {
            switch self {
            case .idle:
                R.Color.gray600
            case .seleceted:
                R.Color.main100
            }
        }
        
        var imageTintColor: UIColor {
            switch self {
            case .idle:
                R.Color.gray700
            case .seleceted:
                R.Color.gray900
            }
        }
    }
}


#Preview {
    DSCheckBox(initialState: .idle, buttonStyle: .init(size: .medium))
}
