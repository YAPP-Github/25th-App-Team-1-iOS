//
//  InputNameView.swift
//  FeatureOnboarding
//
//  Created by ever on 1/9/25.
//

import UIKit
import FeatureThirdPartyDependencies
import FeatureUIDependencies

protocol InputNameViewListener: AnyObject {
    func action(_ action: InputNameView.Action)
}

final class InputNameView: UIView {
    
    enum Action {
        case backButtonTapped
        case nameChanged(String)
        case nextButtonTapped
    }
    
    enum State {
        case setName(String)
        case startEdit
        case shortNameLength
        case invalidName
        case buttonEnabled(Bool)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
        registerForKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: InputNameViewListener?
    
    func update(_ state: State) {
        switch state {
        case let .setName(name):
            nameField.text = name
        case .startEdit:
            nameField.becomeFirstResponder()
        case .shortNameLength:
            showNameLengthError()
        case .invalidName:
            showInvalidNameError()
        case let .buttonEnabled(isEnabled):
            updateNextButtonState(isEnabled)
        }
    }
    
    private let navigationBar: OnBoardingNavBarView = .init()
    private let titleLabel = UILabel()
    private let nameField = DSTextFieldWithTitleWithMessage(
        config: .init(
            textFieldConfig: .init(
                placeholder: "이름 입력",
                alignment: .center,
                keyboardType: .default
            ),
            titleState: .none,
            messageState: .none
        )
    )
    private let termLabel = UILabel()
    private let nextButton: DSDefaultCTAButton = .init(initialState: .inactive)
    
    @objc
    private func nameChanged(_ textField: UITextField) {
        nameField.update(messageState: .none)
        let name = textField.text ?? ""
        listener?.action(.nameChanged(name))
    }
    
    private func showNameLengthError() {
        nameField.update(messageState: .none)
    }
    
    private func showInvalidNameError() {
        nameField.update(messageState: .error("입력한 내용을 확인해주세요.", .center))
    }
    
    private func updateNextButtonState(_ isEnabled: Bool) {
        nextButton.update(state: isEnabled ? .active : .inactive)
    }
}

private extension InputNameView {
    func setupUI() {
        backgroundColor = R.Color.gray900
        navigationBar.do {
            $0.listener = self
            $0.setIndex(4, of: 6)
        }
        
        titleLabel.do {
            $0.displayText = "어떤 이름으로 불리길\n원하시나요?".displayText(font: .title3SemiBold, color: R.Color.white100)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        nameField.do {
            $0.editingChanged = { [weak self] textField in
                guard let self else { return }
                nameChanged(textField)
            }
        }
        nextButton.do {
            $0.update(title: "다음")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.nextButtonTapped)
            }
        }
        
        [navigationBar, titleLabel, nameField, nextButton].forEach {
            addSubview($0)
        }
    }
    
    func layout() {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        nameField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.leading.equalTo(72.5)
            $0.trailing.equalTo(-72.5)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

private extension InputNameView {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(textViewMoveUp(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(textViewMoveDown(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func textViewMoveUp(_ notification: NSNotification){
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        nextButton.snp.updateConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-10 + -keyboardFrame.size.height)
        }
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    @objc
    private func textViewMoveDown(_ notification: NSNotification){
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        nextButton.snp.updateConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
}

extension InputNameView: OnBoardingNavBarViewListener {
    func action(_ action: OnBoardingNavBarView.Action) {
        switch action {
        case .backButtonClicked:
            listener?.action(.backButtonTapped)
        }
    }
}
