//
//  InputBornTImeView.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import UIKit
import FeatureThirdPartyDependencies
import FeatureUIDependencies

protocol InputBornTImeViewListener: AnyObject {
    func action(_ action: InputBornTImeView.Action)
}

final class InputBornTImeView: UIView {
    enum Action {
        case backButtonTapped
        case timeChanged(String)
        case iDontKnowButtonTapped
        case nextButtonTapped
    }
    
    enum State {
        case shortBornTimeLength
        case invalidBornTime
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    weak var listener: InputBornTImeViewListener?
    
    // Internal
    func update(_ state: State) {
        switch state {
        case .shortBornTimeLength:
            showBornTimeLengthError()
        case .invalidBornTime:
            showInvalidBornTimeError()
        case let .buttonEnabled(isEnabled):
            updateNextButtonState(isEnabled)
        }
    }
    
    private let navigationBar: OnBoardingNavBarView = .init()
    private let titleLabel = UILabel()
    private let timeField = DSTextFieldWithTitleWithMessage(
        config: .init(
            textFieldConfig: .init(
                placeholder: "23:59",
                alignment: .center,
                keyboardType: .asciiCapableNumberPad
            ),
            titleState: .none,
            messageState: .none
        )
    )
    private let errorLabel = UILabel()
    private let nextButton = CTAButton(type: .system)
    private let iDontKnowButton = UIButton()
    
    private var labelBottomAnchor: Constraint?
    
    private func showBornTimeLengthError() {
        timeField.update(messageState: .none)
    }
    
    private func showInvalidBornTimeError() {
        timeField.update(messageState: .error("입력한 숫자를 확인해 주세요", .center))
    }
    
    private func updateNextButtonState(_ isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
    }
    
    @objc
    private func timeChanged(_ textField: UITextField) {
        timeField.update(messageState: .none)
        guard let text = textField.text?.replacingOccurrences(of: ":", with: "") else { return }
        var formattedText = ""
        if text.count > 4 {
            // 최대 4자리까지만 입력 허용
            let timeText = text.prefix(4)
            let hour = timeText.prefix(2)
            let minutes = timeText.suffix(2)
            formattedText = [hour, minutes].map { String($0) }.joined(separator: ":")
            textField.text = formattedText
            listener?.action(.timeChanged(formattedText))
            return
        }
        
        if text.count > 2 {
            let hours = text.prefix(2)
            let minutes = text.suffix(from: text.index(text.startIndex, offsetBy: 2))
            formattedText = "\(hours):\(minutes)"
        } else {
            formattedText = text
        }
        textField.text = formattedText
        
        listener?.action(.timeChanged(formattedText))
    }
    
    @objc
    private func iDontKnowButtonTapped() {
        iDontKnowButton.isSelected.toggle()
        
        timeField.update(messageState: .none)
        
        if iDontKnowButton.isSelected {
            endEditing(true)
            timeField.update(textFieldState: .disabled)
        } else {
            timeField.update(textFieldState: .normal)
        }
        listener?.action(.iDontKnowButtonTapped)
    }
    
    @objc
    private func nextButtonTapped() {
        listener?.action(.nextButtonTapped)
    }
}

private extension InputBornTImeView {
    func setupUI() {
        backgroundColor = R.Color.gray900
        navigationBar.listener = self
        navigationBar.setIndex(3, of: 6)
        titleLabel.do {
            $0.displayText = "태어난 시간을 알려주세요".displayText(font: .title3SemiBold, color: R.Color.white100)
        }
        
        timeField.do {
            $0.editingChanged = { [weak self] textField in
                guard let self else { return }
                timeChanged(textField)
            }
        }
        nextButton.do {
            $0.setAttributedTitle("다음".displayText(font: .headline1SemiBold, color: R.Color.gray900), for: .normal)
            $0.setAttributedTitle("다음".displayText(font: .headline1SemiBold, color: R.Color.gray600), for: .disabled)
            $0.normalBackgroundColor = R.Color.main100
            $0.disabledBackgroundColor = R.Color.gray700
            $0.isEnabled = false
            $0.layer.cornerRadius = 16
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        }
        
        iDontKnowButton.do {
            $0.setImage(.init(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = R.Color.white100
            $0.setAttributedTitle("태어난 시간을 몰라요".displayText(font: .body1Medium, color: R.Color.white100), for: .normal)
            $0.setAttributedTitle("태어난 시간을 몰라요".displayText(font: .body1Medium, color: R.Color.main100), for: .selected)
            $0.addTarget(self, action: #selector(iDontKnowButtonTapped), for: .touchUpInside)
        }
        
        
        [navigationBar, titleLabel, timeField, nextButton, iDontKnowButton].forEach {
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
        
        timeField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(60)
            $0.leading.equalTo(72.5)
            $0.trailing.equalTo(-72.5)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-22)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        
        iDontKnowButton.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-26)
            $0.centerX.equalToSuperview()
        }
    }
}

private extension InputBornTImeView {
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
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-22 + -keyboardFrame.size.height)
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
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-22)
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
}

extension InputBornTImeView: OnBoardingNavBarViewListener {
    func action(_ action: FeatureDesignSystem.OnBoardingNavBarView.Action) {
        switch action {
        case .backButtonClicked:
            listener?.action(.backButtonTapped)
        }
    }
}
