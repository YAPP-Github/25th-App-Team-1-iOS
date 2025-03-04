//
//  StartMissionView.swift
//  AlarmMission
//
//  Created by choijunios on 1/21/25.
//

import UIKit

import FeatureUIDependencies

import FeatureThirdPartyDependencies

final class StartMissionView: UIView {
    // Sub view
    private let titleLabel: UILabel = .init()
    
    
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
        titleLabel.transform = titleLabel.transform.scaledBy(x: 0, y: 0)
        addSubview(titleLabel)
    }
    
    private func setupLayout() {
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(140)
            make.centerX.equalToSuperview()
        }
    }
}


// MARK: Public interface
extension StartMissionView {
    @discardableResult
    func update(titleText: String) -> Self {
        titleLabel.displayText =  titleText.displayText(
            font: .title1Bold, color: R.Color.white100
        )
        return self
    }
    
    
    enum AnimationConfig {
        // Duration
        static let titleTextShowupDuration: Double = 0.5
    }
    
    func startShowUpAnimation(completion: (()->Void)? = nil) {
        
        if titleLabel.layer.animation(forKey: "showup_title") != nil {
            titleLabel.layer.removeAnimation(forKey: "showup_title")
        }
        
        // Text animation
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.fromValue = 0.0
        springAnimation.toValue = 1.0
        springAnimation.duration = AnimationConfig.titleTextShowupDuration
        springAnimation.damping = 9.0
        springAnimation.initialVelocity = 30.0
        springAnimation.mass = 0.3
        springAnimation.stiffness = 300.0
        springAnimation.fillMode = .forwards
        springAnimation.isRemovedOnCompletion = false
        titleLabel.layer.add(springAnimation, forKey: "showup_title")
        
        // Completion
        let duration = AnimationConfig.titleTextShowupDuration
        DispatchQueue.main.asyncAfter(deadline: .now()+duration) {
            
            completion?()
        }
    }
}


#Preview {
    
    StartMissionView()
}
