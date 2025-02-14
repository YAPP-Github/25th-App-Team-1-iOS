//
//  ConfigureUserInfoView.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies
import FeatureCommonEntity
import FeatureThirdPartyDependencies

protocol ConfigureUserInfoViewListener: AnyObject {
    func action(_ action: ConfigureUserInfoView.Action)
}

final class ConfigureUserInfoView: UIView, EditBornTimeViewListener {
    // Action
    enum Action {
        case saveButtonTapped
        case backButtonTapped
        case nameTextChanged(text: String)
        case editBirthDateButtonTapped
        case genderButtonTapped(gender: Gender)
        case bornTimeTextChanged(text: String)
        case unknownBornTimeTapped
    }
    
    
    // Listener
    weak var listener: ConfigureUserInfoViewListener?
    
    
    // Sub views
    private let navigationBar: DSAppBar = .init()
    private let backButton: DSDefaultIconButton = .init(
        style: .init(
            type: .default,
            image: FeatureResourcesAsset.gnbLeft.image,
            size: .medium
        )
    )
    private let saveButton: DSLabelButton = .init(config: .init(
        font: .body1Medium,
        textColor: R.Color.gray500
    ))
    // - Name
    private let nameField = DSTextFieldWithTitleWithMessage(config: .init(
        textFieldConfig: .init(
            placeholder: "이름",
            alignment: .left,
            keyboardType: .default
        ),
        titleState: .normal("이름"),
        messageState: .none
    ))
    // - BirthDate
    private let birthDateLabel: UILabel = .init()
    private let editBirthDateButton: InfoButton = .init()
    private let birthDateStack: UIStackView = .init()
    // - Gender
    private let genderLabel: UILabel = .init()
    private let genderButtonStack: UIStackView = .init()
    private let maleButton: EditGenderButton = .init(
        titleText: "남성",
        initialState: .idle
    )
    private let femaleButton: EditGenderButton = .init(
        titleText: "여성",
        initialState: .idle
    )
    private let genderContainerStack: UIStackView = .init()
    // - Borntime
    private let bornTimeLabel: UILabel = .init()
    private let editBornTimeView: EditBornTimeView = .init()
    private let bornTimeContainerStack: UIStackView = .init()
    // - Container
    private let scrollView: UIScrollView = .init()
    private let containerStack: UIStackView = .init()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        observeKeyBoardEvent()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Public interface
extension ConfigureUserInfoView {
    enum Update {
        case saveButton(isEnabled: Bool)
        case name(text: String)
        case nameFieldMsg(messageState: DSTextFieldWithTitleWithMessage.MessageState)
        case birthDate(text: String)
        case gender(gender: Gender)
        case bornTime(text: String)
        case bornTimeFieldMsg(messageState: DSTextFieldWithTitleWithMessage.MessageState)
        case unknownTime(isChecked: Bool)
    }
    func update(_ update: Update) {
        switch update {
        case .saveButton(let isEnabled):
            if isEnabled {
                saveButton.update(config: .init(
                    font: .body1Medium,
                    textColor: R.Color.main100
                ))
                saveButton.isUserInteractionEnabled = true
            } else {
                saveButton.update(config: .init(
                    font: .body1Medium,
                    textColor: R.Color.gray500
                ))
                saveButton.isUserInteractionEnabled = false
            }
        case .name(let text):
            nameField.text = text
        case .nameFieldMsg(let msgState):
            nameField.update(messageState: msgState)
        case .birthDate(let text):
            editBirthDateButton.update(text: text)
        case .gender(let gender):
            switch gender {
            case .male:
                maleButton.update(state: .selected)
                femaleButton.update(state: .idle)
            case .female:
                maleButton.update(state: .idle)
                femaleButton.update(state: .selected)
            }
        case .bornTime(let text):
            editBornTimeView.update(text: text)
        case .bornTimeFieldMsg(let msgState):
            editBornTimeView.update(messageState: msgState)
        case .unknownTime(let isChecked):
            editBornTimeView.update(isTimeUnknown: isChecked)
        }
    }
}


// MARK: Setup
private extension ConfigureUserInfoView {
    func setupUI() {
        // self
        self.backgroundColor = R.Color.gray900
        
        
        // backButton
        backButton.update(image: FeatureResourcesAsset.chevronLeft.image)
        backButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.backButtonTapped)
        }
        
        
        // saveButton
        saveButton.update(titleText: "저장")
        saveButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.saveButtonTapped)
        }
        saveButton.isUserInteractionEnabled = false
        
        
        // navigationBar
        navigationBar.layer.zPosition = 100
        navigationBar
            .update(titleText: "프로필 수정")
            .insertLeftView(backButton)
            .insertRightView(saveButton)
        addSubview(navigationBar)
        
        
        // MARK: SetupUI: 이름
        nameField.editingChanged = { [weak self] textField in
            guard let self else { return }
            if let text = textField.text {
                listener?.action(.nameTextChanged(text: text))
            }
        }
        
        
        // MARK: SetupUI: 생년월일
        // birthDateLabel
        birthDateLabel.displayText = "생년월일".displayText(
            font: .body1Medium,
            color: R.Color.white100
        )
        
        // editBirthDateButton
        editBirthDateButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.editBirthDateButtonTapped)
        }
        
        
        // birthDateStack
        birthDateStack.axis = .vertical
        birthDateStack.spacing = 8
        birthDateStack.alignment = .fill
        [birthDateLabel, editBirthDateButton].forEach {
            birthDateStack.addArrangedSubview($0)
        }
        
        
        // MARK: SetupUI: 젠더
        // genderLabel
        genderLabel.displayText = "성별".displayText(
            font: .body1Medium,
            color: R.Color.white100
        )
        
        // maleButton
        maleButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.genderButtonTapped(gender: .male))
        }
        
        // femaleButton
        femaleButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.genderButtonTapped(gender: .female))
        }
        
        // genderButtonStack
        genderButtonStack.axis = .horizontal
        genderButtonStack.spacing = 8
        genderButtonStack.distribution = .fillEqually
        [maleButton, femaleButton].forEach {
            genderButtonStack.addArrangedSubview($0)
        }
        
        // genderContainerStack
        genderContainerStack.axis = .vertical
        genderContainerStack.spacing = 8
        genderContainerStack.alignment = .fill
        [genderLabel, genderButtonStack].forEach {
            genderContainerStack.addArrangedSubview($0)
        }
        
        
        // MARK: SetupUI: 태어난 시각
        // bornTimeLabel
        bornTimeLabel.displayText = "태어난 시간".displayText(
            font: .body1Medium,
            color: R.Color.white100
        )
        
        // editBornTimeView
        editBornTimeView.listener = self
        
        // bornTimeContainerStack
        bornTimeContainerStack.axis = .vertical
        bornTimeContainerStack.spacing = 8
        bornTimeContainerStack.alignment = .fill
        [bornTimeLabel, editBornTimeView].forEach {
            bornTimeContainerStack.addArrangedSubview($0)
        }
        
        
        // containerStack
        containerStack.layer.zPosition = 50
        containerStack.axis = .vertical
        containerStack.spacing = 24
        containerStack.alignment = .fill
        [nameField, birthDateStack, genderContainerStack, bornTimeContainerStack,  UIView()].forEach {
            containerStack.addArrangedSubview($0)
        }
        scrollView.addSubview(containerStack)
        
        // scrollView
        addSubview(scrollView)
    }
    
    func setupLayout() {
        // navigationBar
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        
        // containerStack
        let scContentGuide = scrollView.contentLayoutGuide
        let scFrameGuide = scrollView.frameLayoutGuide
        containerStack.snp.makeConstraints { make in
            make.edges.equalTo(scContentGuide)
            make.width.equalTo(scFrameGuide)
        }
        
        
        // scrollView
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).inset(-20)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.bottom.equalToSuperview()
        }
    }
}


// MARK: EditBornTimeViewListener
extension ConfigureUserInfoView {
    func action(_ action: EditBornTimeView.Action) {
        switch action {
        case .checkBoxTapped:
            listener?.action(.unknownBornTimeTapped)
        case .editingChanged(let text):
            listener?.action(.bornTimeTextChanged(text: text))
        }
    }
}


// MARK: Keyboard avoidence
private extension ConfigureUserInfoView {
    func observeKeyBoardEvent() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func onKeyboardAppear(_ notification: Notification) {
        var focusedView: UIView?
        if nameField.isFirstResponder {
            focusedView = nameField
        }
        if editBornTimeView.isFirstResponder {
            focusedView = editBornTimeView
        }
        guard let focusedView else { return }
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        let focusViewFrame = focusedView.convert(focusedView.bounds, to: self)
        
        if keyboardEndFrame.minY < focusViewFrame.maxY {
            // 키도드가 해당 뷰를 덮은 경우
            let gap = focusViewFrame.maxY - keyboardEndFrame.minY
            UIView.animate(withDuration: animationDuration) {
                self.scrollView.transform = .init(translationX: 0, y: -gap)
            }
        }
    }
    
    @objc
    func onKeyboardDisappear(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.scrollView.transform = .identity
        }
    }
}
