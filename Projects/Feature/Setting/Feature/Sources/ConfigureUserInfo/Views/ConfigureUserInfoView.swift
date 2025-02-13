//
//  ConfigureUserInfoView.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies

protocol ConfigureUserInfoViewListener: AnyObject {
    func action(_ action: ConfigureUserInfoView.Action)
}

final class ConfigureUserInfoView: UIView, EditBornTimeViewListener {
    // Action
    enum Action {
        case nameTextChanged(text: String)
        case bornTimeTextChanged(text: String)
        case gender
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
    }
    required init?(coder: NSCoder) { nil }
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
        }
        
        
        // saveButton
        saveButton.update(titleText: "저장")
        saveButton.isUserInteractionEnabled = false
        
        
        // navigationBar
        navigationBar
            .update(titleText: "프로필 수정")
            .insertLeftView(backButton)
            .insertRightView(saveButton)
        addSubview(navigationBar)
        
        
        // MARK: SetupUI: 생년월일
        // birthDateLabel
        birthDateLabel.displayText = "생년월일".displayText(
            font: .body1Medium,
            color: R.Color.white100
        )
        
        // editBirthDateButton
        editBirthDateButton.buttonAction = { [weak self] in
            guard let self else { return }
            
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
            
        }
        
        // femaleButton
        femaleButton.buttonAction = { [weak self] in
            guard let self else { return }
            
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
            break
        case .editingChanged(let text):
            break
        }
    }
}
