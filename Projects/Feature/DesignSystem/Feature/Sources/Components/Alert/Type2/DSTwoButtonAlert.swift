//
//  DSTwoButtonAlert.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureResources

import FeatureThirdPartyDependencies

public class DSTwoButtonAlert: UIView {
    
    // SubView
    // - Label
    private let titleLabel: UILabel = .init()
    private let subTitleLabel: UILabel = .init().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let labelStack: UIStackView = .init().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 8
    }
    
    // - Button
    public let leftButton: DSDefaultCTAButton = .init(
        initialState: .active,
        style: .init(
            type: .secondary,
            size: .large,
            cornerRadius: .medium
        ))
    public let rightButton: DSDefaultCTAButton = .init(
        initialState: .active,
        style: .init(
            type: .primary,
            size: .large,
            cornerRadius: .medium
        ))
    private let buttonStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    private let containerStack: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .fill
    }
    
    
    // Configuration
    public let config: Config
    
    
    public init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Setup
private extension DSTwoButtonAlert {
    
    func setupUI() {
        
        // self
        self.backgroundColor = R.Color.gray700
        self.layer.cornerRadius = 20
        
        
        // labels
        [titleLabel, subTitleLabel].forEach({labelStack.addArrangedSubview($0)})
        addSubview(labelStack)
        titleLabel.displayText = config.titleText.displayText(
            font: .heading1SemiBold,
            color: R.Color.gray50
        )
        subTitleLabel.displayText = config.subTitleText.displayText(
            font: .body1Regular,
            color: R.Color.gray300
        )
        
        
        // buttons
        [leftButton, rightButton].forEach({buttonStack.addArrangedSubview($0)})
        addSubview(buttonStack)
        leftButton.update(title: config.leftButtonText)
        rightButton.update(title: config.rightButtonText)
        
        
        // containerStack
        [labelStack, buttonStack].forEach({containerStack.addArrangedSubview($0)})
        addSubview(containerStack)
    }
    
    func setupLayout() {

        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}


// MARK: Public interface
public extension DSTwoButtonAlert {
    
    struct Config {
        let titleText: String
        let subTitleText: String
        let leftButtonText: String
        let rightButtonText: String
        
        public init(titleText: String, subTitleText: String, leftButtonText: String, rightButtonText: String) {
            self.titleText = titleText
            self.subTitleText = subTitleText
            self.leftButtonText = leftButtonText
            self.rightButtonText = rightButtonText
        }
    }
}


#Preview {
    DSTwoButtonAlert(config: .init(
        titleText: "이것은 타이틀 입니다.",
        subTitleText: "이것은 서브타이틀 입니다.",
        leftButtonText: "왼쪽",
        rightButtonText: "오른쪽"
    ))
}
