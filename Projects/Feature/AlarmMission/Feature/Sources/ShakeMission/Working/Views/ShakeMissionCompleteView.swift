//
//  ShakeMissionCompleteView.swift
//  AlarmMission
//
//  Created by choijunios on 1/22/25.
//

import UIKit

import FeatureResources

import SnapKit

final class ShakeMissionCompleteView: UIView {
    
    // Sub view
    private let titleLabel: UILabel = .init().then {
        $0.displayText = "미션 성공!".displayText(
            font: .displayBold, color: R.Color.white100
        )
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setupUI() {
        
        // self
        self.backgroundColor = UIColor(hex: "#17191F").withAlphaComponent(0.7)
        
        // titleLabel
        addSubview(titleLabel)
    }
    
    private func setupLayout() { }
}


// MARK: Public interface
extension ShakeMissionCompleteView {
    
    func startShowUpAnimation(cardView: UIView, duration: CGFloat, completion: (()->Void)? = nil) {
        
        if titleLabel.layer.animation(forKey: "showup_title") != nil {
            titleLabel.layer.removeAnimation(forKey: "showup_title")
        }
        
        // Set label layout
        var cardFrameInSelf = self.convert(cardView.bounds, from: cardView)
        let labelSize = titleLabel.intrinsicContentSize
        cardFrameInSelf.origin.x += (cardView.bounds.width/2-labelSize.width/2)
        cardFrameInSelf.origin.y += (cardView.bounds.height/2-labelSize.height/2)
        titleLabel.frame = .init(
            origin: cardFrameInSelf.origin,
            size: labelSize
        )
        
        // Text animation
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.fromValue = 0.0
        springAnimation.toValue = 1.0
        springAnimation.duration = duration
        springAnimation.damping = 9.0
        springAnimation.initialVelocity = 30.0
        springAnimation.mass = 0.3
        springAnimation.stiffness = 300.0
        springAnimation.fillMode = .forwards
        springAnimation.isRemovedOnCompletion = false
        titleLabel.layer.add(springAnimation, forKey: "showup_title")
        
        
        // Completion
        DispatchQueue.main.asyncAfter(deadline: .now()+duration) {
            
            completion?()
        }
    }
}
