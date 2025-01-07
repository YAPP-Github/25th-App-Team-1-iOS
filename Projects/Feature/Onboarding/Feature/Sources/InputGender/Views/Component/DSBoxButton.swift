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

public protocol DSBoxButtonListener: AnyObject {
    
    func action(sender button: DSBoxButton, action: DSBoxButton.Action)
}

final public class DSBoxButton: UIView {
    
    // View action
    public enum Action {
        case stateChanged(ButtonState)
    }
    
    
    // Sub view
    private let titleLabel: UILabel = .init()
    
    
    // State
    private var buttonState: ButtonState
    
    
    // Listener
    public weak var listener: DSBoxButtonListener?
    
    
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
    
}


// MARK: Public interface
public extension DSBoxButton {
    
    @discardableResult
    func update(title: TitleState) -> Self {
        
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
    
    
    /// 해당매서드로 상태변경시 Listener에게 이벤트가 퍼블리싱 됩니다.
    @discardableResult
    func update(state newState: ButtonState) -> Self {
        
        self.buttonState = newState
        
        switch buttonState {
        case .idle:
            updateAppearance(.default)
        case .selected:
            updateAppearance(.selected)
        }
        
        // publish event
        listener?.action(sender: self, action: .stateChanged(newState))
        
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
}


// MARK: Button appearance
private extension DSBoxButton {
    
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
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
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
