//
//  EditBornTimeView.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies

protocol EditBornTimeViewListener: AnyObject {
    func action(_ action: EditBornTimeView.Action)
}

final class EditBornTimeView: UIView {
    // Action
    enum Action {
        case timeUnknownTapped
        case editingChanged(text: String)
    }
    
    
    // Listener
    weak var listener: EditBornTimeViewListener?
    
    
    // Sub views
    private let bornTimeField = DSTextFieldWithTitleWithMessage(config: .init(
        textFieldConfig: .init(
            placeholder: "시간 모름",
            alignment: .left,
            keyboardType: .decimalPad
        ),
        titleState: .none,
        messageState: .none
    ))
    private let unknownTimeLabel: UILabel = .init()
    private let checkBox: DSCheckBox = .init(
        initialState: .idle,
        buttonStyle: .init(size: .small)
    )
    private let unknownTimeStack: UIStackView = .init()
    
    
    // Gesture
    private let tapGesture: UITapGestureRecognizer = .init()
    
    
    override var isFirstResponder: Bool { bornTimeField.isFirstResponder }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        setupGesture()
    }
    required init?(coder: NSCoder) { nil }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        bornTimeField.resignFirstResponder()
    }
}


// MARK: Public interface
extension EditBornTimeView {
    @discardableResult
    func update(isTimeUnknown: Bool) -> Self {
        checkBox.update(state: isTimeUnknown ? .seleceted : .idle)
        if isTimeUnknown {
            unknownTimeLabel.displayText = unknownTimeLabel.displayText?.string.displayText(
                font: .body1Medium,
                color: R.Color.main100
            )
        } else {
            unknownTimeLabel.displayText = unknownTimeLabel.displayText?.string.displayText(
                font: .body1Medium,
                color: R.Color.white100
            )
        }
        return self
    }
    
    @discardableResult
    func update(text: String) -> Self {
        bornTimeField.text = text
        return self
    }
    
    @discardableResult
    func update(messageState: DSTextFieldWithTitleWithMessage.MessageState) -> Self {
        bornTimeField.update(messageState: messageState)
        return self
    }
    
    @discardableResult
    func update(isTextFieldEnabled: Bool) -> Self {
        bornTimeField.update(textFieldState: isTextFieldEnabled ? .normal : .disabled)
        bornTimeField.isUserInteractionEnabled = isTextFieldEnabled
        return self
    }
}


// MARK: Setup
private extension EditBornTimeView {
    func setupUI() {
        // unknownTimeLabel
        unknownTimeLabel.displayText = "시간 모름".displayText(
            font: .body1Medium,
            color: R.Color.white100
        )
        
        
        // bornTimeField
        bornTimeField.editingChanged = { [weak self] textField in
            guard let self, let text = textField.text else { return }
            listener?.action(.editingChanged(text: text))
        }
        
        
        // checkBox
        checkBox.isUserInteractionEnabled = false
        
        
        // unknownTimeStack
        unknownTimeStack.axis = .horizontal
        unknownTimeStack.spacing = 6
        unknownTimeStack.alignment = .center
        [checkBox, unknownTimeLabel].forEach {
            unknownTimeStack.addArrangedSubview($0)
        }
        
        
        // self
        [bornTimeField, unknownTimeStack].forEach {
            addSubview($0)
        }
    }
    
    func setupLayout() {
        // bornTimeField
        bornTimeField.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.right.equalToSuperview().priority(.high)
            make.right.lessThanOrEqualTo(unknownTimeStack.snp.left).offset(-12)
        }
        
        
        // unknownTimeStack
        unknownTimeStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.right.equalToSuperview()
        }
    }
    
    func setupGesture() {
        unknownTimeStack.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(onTapUnknownButton(_:)))
    }
    
    @objc func onTapUnknownButton(_ sender: UITapGestureRecognizer) {
        listener?.action(.timeUnknownTapped)
    }
}
