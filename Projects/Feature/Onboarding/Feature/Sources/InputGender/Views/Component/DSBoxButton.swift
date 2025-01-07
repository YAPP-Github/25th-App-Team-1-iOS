//
//  DSBoxButton.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

import UIKit

import FeatureResources

import Then
import SnapKit

final public class DSBoxButton: UIView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    
    
    // State
    private var buttonState: ButtonState
    
    
    public override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 148)
    }
    
    
    public init(buttonState: ButtonState = .idle) {
        
        self.buttonState = buttonState
        
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    public required init?(coder: NSCoder) { nil }
    
    
    @discardableResult
    public func update(title: TitleState) -> Self {
        
        var titleText: String = ""
        
        switch title {
        case .none:
            titleText = ""
        case .normal(let string):
            titleText = string
        }
        
        switch buttonState {
        case .idle:
            
            titleLabel.do {
                $0.displayText = titleText.displayText(
                    font: .heading2SemiBold,
                    color: R.Color.white100
                )
            }
            
        case .selected:
            
            titleLabel.do {
                $0.displayText = titleText.displayText(
                    font: .heading2SemiBold,
                    color: R.Color.submain
                )
            }
        }
        
        return self
    }
    
    
    @discardableResult
    public func update(state: ButtonState) -> Self {
        
        self.buttonState = state
        
        let currentTitleText = titleLabel.displayText?.string
        
        switch buttonState {
        case .idle:
            
            // background
            self.backgroundColor = R.Color.gray800
            self.layer.borderWidth = 1
            self.layer.borderColor = R.Color.gray600.cgColor
            
            // text
            if let currentTitleText {
                
                titleLabel.do {
                    $0.displayText = currentTitleText.displayText(
                        font: .heading2SemiBold,
                        color: R.Color.white100
                    )
                }
            }
            
        case .selected:
            
            // background
            self.backgroundColor = R.Color.main10.withAlphaComponent(0.1)
            self.layer.borderWidth = 1
            self.layer.borderColor = R.Color.main40.withAlphaComponent(0.4).cgColor
            
            if let currentTitleText {
                
                titleLabel.do {
                    $0.displayText = currentTitleText.displayText(
                        font: .heading2SemiBold,
                        color: R.Color.submain
                    )
                }
            }
        }
        
        return self
    }
}


// MARK: View configuration
public extension DSBoxButton {
    
    enum ButtonState {
        case idle
        case selected
    }
    
    
    enum TitleState {
        case none
        case normal(String)
    }
}


// MARK: Set up view
private extension DSBoxButton {
    
    private func setupUI() {
        
        // self
        self.layer.cornerRadius = 16
        
        
        // title view
        addSubview(titleLabel)
    }
    
    
    private func setupLayout() {
        
        // title view
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}


// MARK: Previews
#Preview("idle state", traits: .fixedLayout(width: 148, height: 148), body: {
    
    DSBoxButton()
        .update(state: .idle)
        .update(title: .normal("테스트 라벨"))
})


#Preview("selected state", traits: .fixedLayout(width: 148, height: 148), body: {
    
    DSBoxButton()
        .update(state: .selected)
        .update(title: .normal("테스트 라벨"))
})
