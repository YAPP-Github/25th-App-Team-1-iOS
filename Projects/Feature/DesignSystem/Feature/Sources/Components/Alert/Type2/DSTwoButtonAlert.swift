//
//  DSTwoButtonAlert.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureResources

import SnapKit

public class DSTwoButtonAlert: UIView {
    
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
    
    
    // Interaction
    public var leftButtonAction: (() -> Void)?
    public var rightButtonAction: (() -> Void)?
    
    
    public init() {
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
        
        
        // buttons
        [leftButton, rightButton].forEach({buttonStack.addArrangedSubview($0)})
        addSubview(buttonStack)
        
        
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
    
    @discardableResult
    func update(titleText: String) -> Self {
        self.titleLabel.displayText = titleText.displayText(
            font: .heading1SemiBold,
            color: R.Color.gray50
        )
        return self
    }
    
    @discardableResult
    func update(subTitleText: String) -> Self {
        self.subTitleLabel.displayText = subTitleText.displayText(
            font: .body1Regular,
            color: R.Color.gray300
        )
        return self
    }
}


#Preview {
    let view = DSTwoButtonAlert()
    view.leftButton.update(title: "취소")
    view.rightButton.update(title: "삭제")
    view.update(titleText: "알람 삭제")
    view.update(subTitleText: "삭제하시겠어요?")
    return view
}
