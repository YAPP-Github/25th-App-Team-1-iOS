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
    
    
    // gesture
    private let longPressGestureRecognizer: UILongPressGestureRecognizer = .init()
    
    
    public override var intrinsicContentSize: CGSize {
        .init(width: UIView.noIntrinsicMetric, height: 148)
    }
    
    
    public init(buttonState: ButtonState = .idle) {
        
        self.buttonState = buttonState
        
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
        setGestureRecognizer()
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
        
        titleLabel.do {
            $0.displayText = titleText.displayText(font: .heading2SemiBold)
        }
        
        switch buttonState {
        case .idle:
            updateAppearance(.default)
        case .selected:
            updateAppearance(.selected)
        }
    
        return self
    }
    
    
    @discardableResult
    public func update(state: ButtonState) -> Self {
        
        self.buttonState = state
        
        switch buttonState {
        case .idle:
            updateAppearance(.default)
        case .selected:
            updateAppearance(.selected)
        }
        
        // publish event
        
        return self
    }
}


// MARK: View states & appearance
public extension DSBoxButton {
    
    enum ButtonState {
        case idle
        case selected
    }
    
    
    enum TitleState {
        case none
        case normal(String)
    }
    
    
    private enum ButtonAppearance {
        case `default`
        case pressed
        case selected
    }
    
    private func updateAppearance(_ appearance: ButtonAppearance) {
        
        let currentTitleText = titleLabel.displayText?.string
        
        switch appearance {
        case .default:
            
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
            
        case .pressed:
            
            // background
            self.backgroundColor = R.Color.gray700
            self.layer.borderWidth = 0
            
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
    }
}


// MARK: Set up view
private extension DSBoxButton {
    
    func setupUI() {
        
        // self
        self.layer.cornerRadius = 16
        
        
        // title view
        addSubview(titleLabel)
    }
    
    
    func setupLayout() {
        
        // title view
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    
    func setGestureRecognizer() {
        
        longPressGestureRecognizer.minimumPressDuration = 0
        
        addGestureRecognizer(longPressGestureRecognizer)
        longPressGestureRecognizer.addTarget(self, action: #selector(onPress(_:)))
    }
    
    @objc func onPress(_ recognizer: UILongPressGestureRecognizer) {
        
        switch buttonState {
        case .idle:
            UIView.animate(withDuration: 0.2) {
                switch recognizer.state {
                case .began:
                    self.updateAppearance(.pressed)
                case .ended, .cancelled:
                    self.update(state: .selected)
                default:
                    break
                }
            }
        case .selected:
            UIView.animate(withDuration: 0.2) {
                switch recognizer.state {
                case .ended, .cancelled:
                    self.update(state: .idle)
                default:
                    break
                }
            }
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
