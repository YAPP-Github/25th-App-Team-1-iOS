//
//  EditGenderButton.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies

final class EditGenderButton: TouchDetectingView {
    // Sub view
    private let titleLabel: UILabel = .init()
    
    
    // ButtonAction
    var buttonAction: (() -> Void)?
    
    
    // Initial state
    private let titleText: String
    private let initialState: ButtonState
    
    override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 52)
    }
    
    init(titleText: String, initialState: ButtonState) {
        self.titleText = titleText
        self.initialState = initialState
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func onTouchOut() {
        buttonAction?()
    }
}


// MARK: Public interface
extension EditGenderButton {
    @discardableResult
    func update(state: ButtonState) -> Self {
        self.backgroundColor = state.backgroundColor
        self.layer.borderColor = state.borderColor.cgColor
        titleLabel.displayText = titleLabel.displayText?.string.displayText(
            font: .body1Regular,
            color: state.textColor
        )
        return self
    }
    
    enum ButtonState {
        case idle
        case selected
        
        var textColor: UIColor {
            switch self {
            case .idle:
                R.Color.gray400
            case .selected:
                R.Color.main100
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .idle:
                R.Color.gray800
            case .selected:
                R.Color.main10.withAlphaComponent(0.1)
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .idle:
                R.Color.gray700
            case .selected:
                R.Color.main40.withAlphaComponent(0.4)
            }
        }
    }
}


// MARK: Setup
private extension EditGenderButton {
    func setupUI() {
        // self
        self.backgroundColor = initialState.backgroundColor
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 1
        self.layer.borderColor = initialState.borderColor.cgColor
        
        
        // titleLabel
        titleLabel.displayText = titleText.displayText(
            font: .body1Regular,
            color: initialState.textColor
        )
        addSubview(titleLabel)
    }
    
    func setupLayout() {
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
}
