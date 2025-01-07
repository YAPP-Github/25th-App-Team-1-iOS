//
//  InputGenderView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import UIKit

import FeatureResources

protocol InputGenderViewListener: AnyObject {
    
    func action(_ action: InputGenderView.Request)
}

final class InputGenderView: UIView, DSBoxButtonListener, DefaultCTAButtonListener {
    
    // View action
    enum Request {
        case selectedGender(Gender)
    }
    
    
    // Sub view
    private let navigationBar = OnBoardingNavBarView()
    private let titleLabel: UILabel = .init().then {
        $0.displayText = "성별을 알려주세요".displayText(
            font: .heading1SemiBold,
            color: R.Color.white100
        )
    }
    private let maleButton = DSBoxButton()
        .update(state: .idle)
        .update(title: .normal(Gender.male.displayingName))
    private let femaleButton = DSBoxButton()
        .update(state: .idle)
        .update(title: .normal(Gender.female.displayingName))
    private let genderButtonStack: UIStackView = .init().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 16
        }
    private let ctaButton: DefaultCTAButton = .init(initialState: .active).then {
        $0.update("다음")
        $0.update(state: .inactive)
    }
    private let policyAgreementLabel = PolicyAgreementLabel()
    private let buttonAndTextStack: UIStackView = .init().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .fill
            $0.spacing = 14
        }
    
    
    // Listener
    weak var listener: InputGenderViewListener?
    
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Set up view
private extension InputGenderView {
    
    func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray900
        
        
        // navigationBarView
        addSubview(navigationBar)
        
        
        // title label
        addSubview(titleLabel)
        
        
        // genderButtonStack
        [maleButton, femaleButton].forEach {
            genderButtonStack.addArrangedSubview($0)
        }
        addSubview(genderButtonStack)
        
        
        // button and text
        [ctaButton, policyAgreementLabel].forEach {
            buttonAndTextStack.addArrangedSubview($0)
        }
        addSubview(buttonAndTextStack)
    }
    
    
    func setupLayout() {
        
        // navigationBar
        addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(38)
            make.centerX.equalToSuperview()
        }
        
        
        // genderButtonStack
        genderButtonStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        
        // buttonAndTextStack
        buttonAndTextStack.snp.makeConstraints { make in
            
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}


// MARK: DSBoxButtonListener
extension InputGenderView {
    
    func action(sender button: DSBoxButton, action: DSBoxButton.Action) {
        
        //
    }
}


// MARK: DefaultCTAButtonListener
extension InputGenderView {
    
    func action(_ action: DefaultCTAButton.Action) {
        
        //
    }
}
