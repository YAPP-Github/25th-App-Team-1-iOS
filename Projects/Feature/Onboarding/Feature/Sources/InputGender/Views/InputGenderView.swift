//
//  InputGenderView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import UIKit

import FeatureUIDependencies

protocol InputGenderViewListener: AnyObject {
    func action(_ action: InputGenderView.Action)
}

final class InputGenderView: UIView, DSBoxButtonListener, OnBoardingNavBarViewListener {
    
    // View action
    enum Action {
        case selectedGender(Gender?)
        case confirmButtonClicked
        case backButtonClicked
    }
    
    
    // Sub view
    let navigationBar = OnBoardingNavBarView()
    let titleLabel: UILabel = .init().then {
        $0.displayText = "성별을 알려주세요".displayText(
            font: .heading1SemiBold,
            color: R.Color.white100
        )
    }
    let maleButton = DSBoxButton()
        .update(state: .idle)
        .update(title: .normal(Gender.male.displayingName))
    let femaleButton = DSBoxButton()
        .update(state: .idle)
        .update(title: .normal(Gender.female.displayingName))
    let genderButtonStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 15
    }
    let ctaButton: DSDefaultCTAButton = .init(initialState: .active).then {
        $0.update(title: "다음")
        $0.update(state: .inactive)
    }
    let buttonAndTextStack: UIStackView = .init().then {
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
        navigationBar.listener = self
        navigationBar.setIndex(5, of: 6)
        
        
        // title label
        addSubview(titleLabel)
        
        
        // genderButtonStack
        [maleButton, femaleButton].forEach {
            genderButtonStack.addArrangedSubview($0)
        }
        maleButton.listener = self
        femaleButton.listener = self
        addSubview(genderButtonStack)
        
        
        // button and text
        [ctaButton].forEach {
            buttonAndTextStack.addArrangedSubview($0)
        }
        ctaButton.buttonAction = { [weak self] in
            self?.listener?.action(.confirmButtonClicked)
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
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(38)
        }
        
        
        // buttonAndTextStack
        buttonAndTextStack.snp.makeConstraints { make in
            
            make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}

// MARK: public interface
extension InputGenderView {
    
    func updateCtaButton(isEnabled: Bool) {
        
        ctaButton.update(state: isEnabled ? .active : .inactive)
    }
}


// MARK: DSBoxButtonListener
extension InputGenderView {
    
    func action(sender button: DSBoxButton, action: DSBoxButton.Action) {
        
        switch action {
        case .stateChanged(let buttonState):
            
            switch buttonState {
            case .idle:
                
                // publish event
                listener?.action(.selectedGender(nil))
                
                break
            case .selected:
                switch button {
                case maleButton:
                    
                    // publish event
                    listener?.action(.selectedGender(.male))
                    
                    // apply radio ui
                    femaleButton.update(state: .idle, animated: true)
                    
                case femaleButton:
                    
                    // publish event
                    listener?.action(.selectedGender(.female))
                    
                    // apply radio ui
                    maleButton.update(state: .idle, animated: true)
                    
                default:
                    fatalError()
                }
            }
        }
    }
}

// MARK: OnBoardingNavBarViewListener
extension InputGenderView {
    
    func action(_ action: OnBoardingNavBarView.Action) {
        
        listener?.action(.backButtonClicked)
    }
}
