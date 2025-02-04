//
//  InputSummaryView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/15/25.
//

import UIKit

import FeatureUIDependencies

import FeatureThirdPartyDependencies

protocol InputSummaryViewListener: AnyObject {
    
    func action(_ action: InputSummaryView.Action)
}


final class InputSummaryView: UIView {
    
    // Action
    enum Action {
        case agreeInSumamry
        case disagreeInSummary
    }
    
    
    // Listener
    weak var listener: InputSummaryViewListener?
    
    
    // Sub views
    private let containerView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let inputSummaryStack: UIStackView = .init().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 0
    }
    private let disagreeButton: DSDefaultCTAButton = .init(
        initialState: .active,
        style: .init(type: .secondary, size: .large, cornerRadius: .medium)
    )
    private let agreeButton: DSDefaultCTAButton = .init(
        initialState: .active,
        style: .init(type: .primary, size: .large, cornerRadius: .medium)
    )
    private let buttonStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipContainerView()
    }
}


// MARK: Public interface
extension InputSummaryView {
    
    func update(isPresent: Bool) {
        if isPresent {
            self.backgroundColor = .black.withAlphaComponent(0.8)
            containerView.transform = .identity
        } else {
            self.backgroundColor = .clear
            let height = containerView.layer.bounds.height
            containerView.transform = containerView.transform.translatedBy(x: 0, y: height)
        }
    }
    
    func update(inputs: [String: String]) {
        inputSummaryStack.arrangedSubviews.forEach {$0.removeFromSuperview()}
        inputs.forEach { keyText, valueText in
            let rowView = SummaryRowView()
                .update(keyText: keyText)
                .update(valueText: valueText)
            inputSummaryStack.addArrangedSubview(rowView)
        }
        layoutIfNeeded()
    }
}


// MARK: Set up
private extension InputSummaryView {
    
    func setupUI() {
        
        // containerView
        containerView.backgroundColor = R.Color.gray800
        addSubview(containerView)
        
        
        // titleLabel
        titleLabel.do {
            $0.displayText = "입력하신 정보가 맞나요?"
                .displayText(font: .heading2SemiBold, color: .white)
        }
        containerView.addSubview(titleLabel)
        
        
        // inputSummaryTable
        containerView.addSubview(inputSummaryStack)
        
        
        // disagreeButton
        disagreeButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.disagreeInSummary)
        }
        disagreeButton.update(title: "아니에요")
        
        // agreeButton
        agreeButton.buttonAction = { [weak self] in
            guard let self else { return }
            listener?.action(.agreeInSumamry)
        }
        agreeButton.update(title: "맞아요")
        
        
        // buttonStack
        [disagreeButton, agreeButton].forEach {
            buttonStack.addArrangedSubview($0)
        }
        containerView.addSubview(buttonStack)
    }
    
    
    func setupLayout() {
        
        // containerView
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.leading.equalToSuperview().inset(24)
        }
        
        
        // inputSummaryTable
        inputSummaryStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-20)
            make.horizontalEdges.equalToSuperview()
        }
        
        
        // buttonStack
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(inputSummaryStack.snp.bottom).inset(-24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
    }
    
    
    func clipContainerView() {
        
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 30, height: 30)
        )
        let clippingLayer = CAShapeLayer()
        clippingLayer.path = path.cgPath
        clippingLayer.frame = containerView.layer.bounds
        containerView.layer.mask = clippingLayer
    }
}


#Preview {
    let view = InputSummaryView()
    view.update(inputs: [
        "타입1": "값1",
        "타입2": "값2",
        "타입3": "값3",
        "타입4": "값4",
    ])
    return view
}
