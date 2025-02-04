//
//  DSTextFieldWithTitleWithMessage.swift
//  FeatureOnboarding
//
//  Created by ever on 1/7/25.
//

import UIKit
import FeatureThirdPartyDependencies
import FeatureResources

public final class DSTextFieldWithTitleWithMessage: UIView {
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    private let textField: DSTextField
    
    private let config: Config
    private var titleState: TitleState
    private var messageState: MessageState
    
    public init(config: Config) {
        self.config = config
        self.titleState = config.titleState
        self.messageState = config.messageState
        self.textField = .init(config: config.textFieldConfig)
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var editingChanged: ((UITextField) -> Void)? {
        didSet {
            textField.editingChanged = editingChanged
        }
    }
    
    public func update(messageState: MessageState) {
        self.messageState = messageState
        update()
    }
    
    public func update(titleState: TitleState) {
        self.titleState = titleState
        update()
    }
    
    public func update(textFieldState state: DSTextField.State) {
        textField.update(state: state)
    }
    
    private func update() {
        switch titleState {
        case .none:
            titleLabel.isHidden = true
        case let .normal(title):
            titleLabel.isHidden = false
            titleLabel.displayText = title.displayText(font: .body1Medium, color: R.Color.white100)
        }
        
        switch messageState {
        case .none:
            messageLabel.isHidden = true
            textField.hasError = false
        case let .normal(message, alignment):
            messageLabel.isHidden = false
            messageLabel.displayText = message.displayText(font: .body1Regular, color: R.Color.white100)
            messageLabel.textAlignment = alignment
            
            textField.hasError = false
        case let .error(message, alignment):
            messageLabel.isHidden = false
            messageLabel.displayText = message.displayText(font: .body1Regular, color: R.Color.statusAlert)
            messageLabel.textAlignment = alignment
            
            textField.hasError = true
        }
    }
}

public extension DSTextFieldWithTitleWithMessage {
    struct Config {
        public let textFieldConfig: DSTextField.Config
        public let titleState: TitleState
        public let messageState: MessageState
        
        public init(textFieldConfig: DSTextField.Config, titleState: TitleState, messageState: MessageState) {
            self.textFieldConfig = textFieldConfig
            self.titleState = titleState
            self.messageState = messageState
        }
    }
    
    enum TitleState {
        case none
        case normal(String)
    }
    
    enum MessageState {
        case none
        case normal(String, NSTextAlignment)
        case error(String, NSTextAlignment)
    }
}

private extension DSTextFieldWithTitleWithMessage {
    func setupUI() {
        stackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 12
        }
        [titleLabel, textField, messageLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
    }
    func layout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

public extension DSTextFieldWithTitleWithMessage {
    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
}
