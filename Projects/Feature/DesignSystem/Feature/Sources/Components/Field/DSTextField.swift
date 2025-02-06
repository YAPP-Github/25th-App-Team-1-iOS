//
//  DSTextField.swift
//  FeatureOnboarding
//
//  Created by ever on 1/6/25.
//

import UIKit
import FeatureThirdPartyDependencies
import FeatureResources

public class DSTextField: UIView {
    private var state: State = .normal
    private let config: Config
    
    public var hasError: Bool = false {
        didSet {
            update()
        }
    }
    
    public init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        return .init(width: UIView.noIntrinsicMetric, height: 54)
    }
    
    public var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    public var editingChanged: ((UITextField) -> Void)?
    
    public func update(state: State) {
        self.state = state
        update()
    }
    
    private func update() {
        if hasError {
            layer.borderColor = R.Color.statusAlert.cgColor
        } else {
            layer.borderColor = state.borderColor
        }
        
        layer.borderWidth = state.borderWidth
        
        if case .disabled = state {
            textField.isEnabled = false
            textField.text = nil
        } else {
            textField.isEnabled = true
        }
    }
    
    private let textField = UITextField()
    private let clearButton = UIButton(type: .system)
    
    @objc
    private func editingDidBegin() {
        state = .focused
        if let text = textField.text, !text.isEmpty {
            clearButton.alpha = 1
        } else {
            clearButton.alpha = 0
        }
        update()
    }
    
    @objc
    private func editingDidChange(textField: UITextField) {
        editingChanged?(textField)
        if let text = textField.text, !text.isEmpty {
            clearButton.alpha = 1
        } else {
            clearButton.alpha = 0
        }
    }
    
    @objc
    private func editingDidEnd(textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            state = .normal
        } else {
            state = .completed
        }
        clearButton.alpha = 0
        update()
    }
    
    @objc
    private func clearButtonTapped() {
        clearButton.alpha = 0
        textField.text = ""
        editingChanged?(textField)
    }
}

public extension DSTextField {
    enum State {
        case normal
        case focused
        case completed
        case error
        case disabled
        
        var borderColor: CGColor {
            switch self {
            case .normal:
                return R.Color.gray600.cgColor
            case .focused:
                return R.Color.main20.cgColor
            case .completed:
                return R.Color.gray800.cgColor
            case .error:
                return R.Color.statusAlert.cgColor
            case .disabled:
                return UIColor.clear.cgColor
            }
        }
        
        var borderWidth: CGFloat {
            if case .focused = self {
                return 3
            }
            return 1
        }
    }
    
    struct Config {
        let placeholder: String
        let alignment: NSTextAlignment
        let keyboardType: UIKeyboardType
        
        public init(placeholder: String, alignment: NSTextAlignment, keyboardType: UIKeyboardType) {
            self.placeholder = placeholder
            self.alignment = alignment
            self.keyboardType = keyboardType
        }
    }
}

private extension DSTextField {
    func setupUI() {
        backgroundColor = R.Color.gray800
        layer.borderWidth = 1
        layer.borderColor = state.borderColor
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        
        textField.do {
            $0.attributedPlaceholder = config.placeholder.displayText(font: .body1Regular, color: R.Color.gray500)
            $0.font = R.Font.body1Regular.toUIFont()
            $0.textAlignment = config.alignment
            $0.textColor = R.Color.white100
            $0.keyboardType = config.keyboardType
            $0.tintColor = .white
            $0.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
            $0.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
            $0.addTarget(self, action: #selector(editingDidChange), for: .editingChanged)
        }
        
        clearButton.do {
            $0.setImage(FeatureResourcesAsset.svgCloseCircleFill.image.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.alpha = 0
            $0.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        }
        addSubview(textField)
        addSubview(clearButton)
    }
    func layout() {
        clearButton.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(14)
            $0.bottom.equalTo(-14)
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
        }
    }
}

public extension DSTextField {
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
