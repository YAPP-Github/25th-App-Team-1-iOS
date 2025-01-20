//
//  DSDefaultCTAButton.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/6/25.
//

import UIKit

import FeatureResources

import SnapKit

public final class DSDefaultCTAButton: TouchDetectingView {
    // Sub view
    private let titleLabel: UILabel = .init()
    
    // Listener
    public var buttonAction: (() -> Void)?

    // State
    private var state: State
    private var style: ButtonStyle
    private(set) var title: String = ""
    public var isEnabled: Bool { state == .active }
    
    // Gesture
    private let tapRecognizer: UITapGestureRecognizer = .init()
    public override func onTouchIn() {
        self.backgroundColor = style.type.pressedBackgroundColor
        self.titleLabel.displayText = title.displayText(
            font: style.size.font,
            color: style.type.pressedTitleColor
        )
        self.layer.cornerRadius = style.cornerRadius.pressedValue
    }
    
    public override func onTouchOut() {
        self.backgroundColor = style.type.backgroundColor
        self.titleLabel.displayText = title.displayText(
            font: style.size.font,
            color: style.type.titleColor
        )
        self.layer.cornerRadius = style.cornerRadius.value
    }
    
    
    //
    private let baseFont: R.Font = .body1SemiBold
    
    
    public override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 54)
    }
    
    
    public init(
        initialState: State = .active, 
        style: ButtonStyle = .init()
    ) {
        self.style = style
        self.state = initialState
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setupTapGesture()
    }
    public required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        // self
        self.backgroundColor = style.type.backgroundColor
        self.layer.cornerRadius = style.cornerRadius.value
        self.clipsToBounds = true
    }
    
    
    private func setupLayout() {
        // titleLabel
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    private func setupTapGesture() {
        tapRecognizer.addTarget(self, action: #selector(onTap(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    
    @objc
    private func onTap(_ gesture: UIGestureRecognizer) {
        buttonAction?()
    }
}


// MARK: Public interface
public extension DSDefaultCTAButton {
    func update(title: String) {
        self.title = title
        updateAppearance()
    }
    
    func update(state: State) {
        self.state = state
        self.updateAppearance()
    }
}


// MARK: State
extension DSDefaultCTAButton {
    
    public enum State {
        case active
        case inactive
    }
    
    
    private func updateAppearance() {
        switch state {
        case .active:
            self.isUserInteractionEnabled = true
            backgroundColor = style.type.backgroundColor
            titleLabel.displayText = title.displayText(
                font: style.size.font,
                color: style.type.titleColor
            )
        case .inactive:
            self.isUserInteractionEnabled = false
            backgroundColor = R.Color.gray700
            titleLabel.displayText = title.displayText(
                font: style.size.font,
                color: R.Color.gray600
            )
        }
    }
}

extension DSDefaultCTAButton {
    public struct ButtonStyle {
        var type: ButtonType
        var size: ButtonSize
        var cornerRadius: CornerRadius
        
        public init(
            type: ButtonType = .primary,
            size: ButtonSize = .large,
            cornerRadius: CornerRadius = .medium
        ) {
            self.type = type
            self.size = size
            self.cornerRadius = cornerRadius
        }
    }
    
    public enum ButtonType {
        case primary
        case secondary
        case tertiary
        case tertiary20
        case transparent
        
        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return R.Color.main100
            case .secondary:
                return R.Color.gray600
            case .tertiary:
                return R.Color.white100
            case .tertiary20:
                return R.Color.white20
            case .transparent:
                return .clear
            }
        }
        
        var pressedBackgroundColor: UIColor {
            switch self {
            case .primary:
                return R.Color.main80
            case .secondary:
                return R.Color.gray500
            case .tertiary:
                return R.Color.white80
            case .tertiary20:
                return R.Color.white20
            case .transparent:
                return .clear
            }
        }
        
        var titleColor: UIColor {
            switch self {
            case .primary:
                return R.Color.gray900
            case .secondary:
                return R.Color.white100
            case .tertiary:
                return R.Color.gray900
            case .tertiary20:
                return R.Color.white100
            case .transparent:
                return R.Color.white100
            }
        }
        
        var pressedTitleColor: UIColor {
            switch self {
            case .primary:
                return R.Color.gray600
            case .secondary:
                return R.Color.white70
            case .tertiary:
                return R.Color.gray600
            case .tertiary20:
                return R.Color.white100
            case .transparent:
                return R.Color.white70
            }
        }
    }
    
    public enum ButtonSize {
        case extraLarge
        case large
        case medium
        
        var font: R.Font {
            switch self {
            case .extraLarge:
                return .headline1SemiBold
            case .large:
                return .body1SemiBold
            case .medium:
                return .body1SemiBold
            }
        }
    }
    
    public enum CornerRadius {
        case medium
        case small
        
        var value: CGFloat {
            switch self {
            case .medium:
                return 16
            case .small:
                return 0
            }
        }
        
        var pressedValue: CGFloat {
            switch self {
            case .medium:
                return 12
            case .small:
                return 0
            }
        }
    }
}


#Preview("활성 상태") {
    
    let view = DSDefaultCTAButton(
        initialState: .active,
        style: .init()
    )
    view.update(title: "안녕하세요")
    
    return view
}

#Preview("비활성 상태") {
    
    let view = DSDefaultCTAButton(
        initialState: .inactive,
        style: .init()
    )
    view.update(title: "안녕하세요")
    
    return view
}
