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
    
    
    // Gesture
    private let tapGestureRecognizer: UITapGestureRecognizer = .init()
    
    
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
        setupGesture()
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
        case bornTimeFieldEnability(isEnabled: Bool)
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
            if editBornTimeView.isFirstResponder {
                self.layoutIfNeeded()
                let contentHeight = scrollView.contentSize.height
                let scrollViewHeight = scrollView.bounds.height
                if contentHeight > scrollViewHeight {
                    // 키보드에 의해 컨텐츠가 밀어올려져 스크롤이 가능한 상태, 스크롤을 가장 아래로 이동
                    scrollView.contentOffset.y = contentHeight-scrollViewHeight
                }
            }
        case .bornTimeFieldEnability(let isEnabled):
            editBornTimeView.update(isTextFieldEnabled: isEnabled)
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
        backButton.layer.zPosition = 100
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
        navigationBar.backgroundColor = R.Color.gray900
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
        scrollView.layer.zPosition = 50
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
    
    func setupGesture() {
        tapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(onTapAnyWhere(_:)))
    }
    @objc
    func onTapAnyWhere(_ sender: UITapGestureRecognizer) {
        if editBornTimeView.isFirstResponder {
            editBornTimeView.resignFirstResponder()
        }
        if nameField.isFirstResponder {
            nameField.resignFirstResponder()
        }
    }
}


// MARK: EditBornTimeViewListener
extension ConfigureUserInfoView {
    func action(_ action: EditBornTimeView.Action) {
        switch action {
        case .timeUnknownTapped:
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
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        
        // 뷰의 하단 제약을 갱신
        UIView.animate(withDuration: animationDuration) {
            let scrollView = self.scrollView
            scrollView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(keyboardEndFrame.height)
            }
            self.layoutIfNeeded()
            scrollView.contentOffset.y = (scrollView.contentSize.height-scrollView.bounds.height)
        }
    }
    
    @objc
    func onKeyboardDisappear(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.scrollView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            self.layoutIfNeeded()
        }
    }
}
