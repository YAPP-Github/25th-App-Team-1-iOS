//
//  DSTextField.swift
//  FeatureOnboarding
//
//  Created by ever on 1/6/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources

public class DSTextField: UIView {
    private var state: State = .normal
    private let config: Config
    
    var error: String? {
        didSet {
            update()
        }
    }
    
    init(config: Config) {
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
    
    var editingChanged: ((UITextField) -> Void)?
    
    private func update() {
        if error != nil {
            layer.borderColor = R.Color.statusAlert.cgColor
        } else {
            layer.borderColor = state.borderColor
        }
    }
    
    private let textField = UITextField()
    
    @objc
    private func editingDidBegin() {
        state = .focused
        update()
    }
    
    @objc
    private func editingDidChange(textField: UITextField) {
        editingChanged?(textField)
    }
    
    @objc
    private func editingDidEnd(textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            state = .normal
        } else {
            state = .completed
        }
        update()
    }
}

public extension DSTextField {
    enum State {
        case normal
        case focused
        case completed
        case error(message: String)
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
    }
    
    struct Config {
        let placeholder: String
        let alignment: NSTextAlignment
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
            $0.tintColor = .white
            $0.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
            $0.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
            $0.addTarget(self, action: #selector(editingDidChange), for: .editingChanged)
        }
        addSubview(textField)
    }
    func layout() {
        textField.snp.makeConstraints {
            $0.top.equalTo(14)
            $0.bottom.equalTo(-14)
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
        }
    }
}
