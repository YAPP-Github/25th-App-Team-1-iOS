//
//  DSToggle.swift
//  DesignSystem
//
//  Created by choijunios on 2/12/25.
//

import UIKit

import FeatureResources

import SnapKit

public final class DSToggle: TouchDetectingView {
    // State
    private let initialState: ToggleState
    private var isEnabled: Bool
    
    
    // Action
    public var toggleAction: (() -> Void)?
    
    
    // Sub view
    private let switchBall: UIView = .init()
    private var switchBallLeftConstraint: NSLayoutConstraint?
    private var switchBallRightConstraint: NSLayoutConstraint?
    
    
    // ContentSize
    public override var intrinsicContentSize: CGSize {
        .init(width: 46, height: 26)
    }
    
    
    public init(initialState: ToggleState) {
        self.initialState = initialState
        self.isEnabled = initialState.isEnabled
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        apply(state: initialState)
    }
    public required init?(coder: NSCoder) { nil }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height/2
        switchBall.layer.cornerRadius = switchBall.layer.bounds.height/2
    }
    
    public override func onTouchOut() {
        if isEnabled {
            toggleAction?()
        }
    }
    
    private func apply(state: ToggleState) {
        self.backgroundColor = state.backgroundColor
        self.switchBall.backgroundColor = state.switchColor
        
        switch state.switchState {
        case .on:
            self.switchBallLeftConstraint?.isActive = false
            self.switchBallRightConstraint?.isActive = true
        case .off:
            self.switchBallLeftConstraint?.isActive = true
            self.switchBallRightConstraint?.isActive = false
        }
    }
}


// MARK: Setup
private extension DSToggle {
    func setupUI() {
        // switchBall
        switchBall.isUserInteractionEnabled = false
        switchBall.layer.shadowColor = UIColor.black.cgColor
        switchBall.layer.shadowOpacity = 0.1
        switchBall.layer.shadowOffset = .init(width: 0, height: 4)
        switchBall.layer.shadowRadius = 2
        addSubview(switchBall)
    }
    
    func setupLayout() {
        // switchBall
        switchBall.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            switchBall.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            switchBall.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            switchBall.widthAnchor.constraint(equalTo: switchBall.heightAnchor),
        ])
        self.switchBallLeftConstraint = switchBall.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 3)
        self.switchBallRightConstraint = switchBall.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3)
        switch initialState.switchState {
        case .on:
            switchBallRightConstraint?.isActive = true
        case .off:
            switchBallLeftConstraint?.isActive = true
        }
    }
}


// MARK: Public interface
public extension DSToggle {
    func update(state: ToggleState) {
        self.isEnabled = state.isEnabled
        self.apply(state: state)
    }
    
    
    struct ToggleState {
        public enum SwitchState {
            case on, off
        }
        var isEnabled: Bool
        var switchState: SwitchState
        
        public init(isEnabled: Bool, switchState: SwitchState) {
            self.isEnabled = isEnabled
            self.switchState = switchState
        }
        
        var backgroundColor: UIColor {
            switch switchState {
            case .on:
                isEnabled ? R.Color.main100 : R.Color.gray700
            case .off:
                isEnabled ? R.Color.gray600 : R.Color.gray700
            }
        }
        
        var switchColor: UIColor {
            switch switchState {
            case .on:
                isEnabled ? R.Color.gray800 : R.Color.gray500
            case .off:
                isEnabled ? R.Color.gray300 : R.Color.gray500
            }
        }
    }
}

#Preview {
    DSToggle(initialState: .init(
        isEnabled: true,
        switchState: .on
    ))
}

#Preview {
    DSToggle(initialState: .init(
        isEnabled: true,
        switchState: .off
    ))
}

#Preview {
    DSToggle(initialState: .init(
        isEnabled: false,
        switchState: .on
    ))
}

#Preview {
    DSToggle(initialState: .init(
        isEnabled: false,
        switchState: .off
    ))
}
