//
//  DSButtonAlert.swift
//  FeatureDesignSystem
//
//  Created by ever on 2/7/25.
//

import UIKit

import FeatureResources
import FeatureThirdPartyDependencies

public class DSButtonAlert: UIView {
    
    // SubView
    // - Label
    private let titleLabel: UILabel = .init()
    private let subTitleLabel: UILabel = .init()
    private let labelStack: UIStackView = .init().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 8
    }
    
    // - Button
    public let button: DSDefaultCTAButton = .init(
        initialState: .active,
        style: .init(
            type: .primary,
            size: .large,
            cornerRadius: .medium
        ))
    
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
private extension DSButtonAlert {
    
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
        addSubview(button)
        button.update(title: config.buttonText)
        
        // containerStack
        [labelStack, button].forEach({containerStack.addArrangedSubview($0)})
        addSubview(containerStack)
    }
    
    func setupLayout() {

        containerStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}


// MARK: Public interface
public extension DSButtonAlert {
    struct Config {
        let titleText: String
        let subTitleText: String
        let buttonText: String
        
        public init(titleText: String, subTitleText: String, buttonText: String) {
            self.titleText = titleText
            self.subTitleText = subTitleText
            self.buttonText = buttonText
        }
    }
}
