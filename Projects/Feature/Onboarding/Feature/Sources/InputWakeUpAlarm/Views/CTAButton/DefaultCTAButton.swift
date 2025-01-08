//
//  DefaultCTAButton.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/6/25.
//

import UIKit

import FeatureResources

import SnapKit

public protocol DefaultCTAButtonListener: AnyObject {
    
    func action(_ action: DefaultCTAButton.Action)
}

public final class DefaultCTAButton: UIView {
    
    // Action
    public enum Action {
        case buttonIsTapped
    }
    
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private let fadeView: UIView = .init()
    
    
    // Listener
    public weak var listener: DefaultCTAButtonListener?
    

    // State
    private var state: State = .active
    public var isEnabled: Bool { state == .active }
    
    
    // Gesture
    private let tapRecognizer: UITapGestureRecognizer = .init()
    
    
    //
    private let baseFont: R.Font = .body1SemiBold
    
    
    public override var intrinsicContentSize: CGSize {
        
        .init(width: UIView.noIntrinsicMetric, height: 54)
    }
    
    
    public init(initialState: State = .active) {
    
        super.init(frame: .zero)
        
        update(state: initialState)
        
        setupUI()
        setupLayout()
        setupTapGesture()
    }
    public required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        
        // self
        layer.cornerRadius = 16
        self.clipsToBounds = true
        
        
        // fadeView
        fadeView.alpha = 0
        fadeView.isUserInteractionEnabled = false
        fadeView.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    
    private func setupLayout() {
        
        // titleLabel
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        
        // fadeView
        addSubview(fadeView)
        fadeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    private func setupTapGesture() {
        tapRecognizer.addTarget(self, action: #selector(onTap(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    
    @objc
    private func onTap(_ gesture: UIGestureRecognizer) {
        
        listener?.action(.buttonIsTapped)
        
        // tap anim
        fadeView.alpha = 1
        UIView.animate(withDuration: 0.35) {
            self.fadeView.alpha = 0
        }
    }
}


// MARK: Public interface
public extension DefaultCTAButton {
    
    func update(_ text: String) {
        updateAppearance(text: text, state: self.state)
    }
    
    func update(state: State, animated: Bool = false) {
        self.state = state
        self.isUserInteractionEnabled = (state == .active)
        
        UIView.animate(withDuration: animated ? 0.35 : 0.0) {
            
            let currentTitleText = self.titleLabel.displayText?.string
            
            self.updateAppearance(
                text: currentTitleText,
                state: state
            )
        }
    }
}


// MARK: State
extension DefaultCTAButton {
    
    public enum State {
        case active
        case inactive
    }
    
    
    private func updateAppearance(text: String?, state: State) {
        
        switch state {
        case .active:
            
            self.backgroundColor = R.Color.main100
            if let text {
                
                titleLabel.displayText = text.displayText(
                    font: baseFont,
                    color: R.Color.gray900
                )
            }
            
            
        case .inactive:
            
            self.backgroundColor = R.Color.gray700
            if let text {
                
                titleLabel.displayText = text.displayText(
                    font: baseFont,
                    color: R.Color.gray600
                )
            }
        }
    }
}


#Preview("활성 상태") {
    
    let view = DefaultCTAButton()
    view.update("안녕하세요")
    
    return view
}

#Preview("비활성 상태") {
    
    let view = DefaultCTAButton()
    view.update("안녕하세요")
    view.update(state: .inactive)
    
    return view
}
