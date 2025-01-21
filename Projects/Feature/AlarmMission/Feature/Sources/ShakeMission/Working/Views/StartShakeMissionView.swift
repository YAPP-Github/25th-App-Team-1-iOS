//
//  StartShakeMissionView.swift
//  AlarmMission
//
//  Created by choijunios on 1/21/25.
//

import UIKit

import FeatureResources

import SnapKit

final class StartShakeMissionView: UIView {
    
    // Sub view
    private let titleLabel: UILabel = .init().then {
        $0.displayText = "흔들기 시작!".displayText(
            font: .title1Bold, color: R.Color.white100
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
        self.layer.backgroundColor = UIColor.clear.cgColor
        
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
extension StartShakeMissionView {
    
    func startShowUpAnimation(duration: CGFloat, completion: (()->Void)? = nil) {
        
        if self.layer.animation(forKey: "showup_backround") != nil, titleLabel.layer.animation(forKey: "showup_title") != nil {
            self.layer.removeAnimation(forKey: "showup_backround")
            titleLabel.layer.removeAnimation(forKey: "showup_title")
        }
        
        // Background animation
        let backgroundAnim = CABasicAnimation(keyPath: "backgroundColor")
        let targetBackgroundColor = UIColor(hex: "#17191F").withAlphaComponent(0.7).cgColor
        backgroundAnim.fromValue = UIColor.clear.cgColor
        backgroundAnim.toValue = targetBackgroundColor
        backgroundAnim.duration = duration
        backgroundAnim.fillMode = .forwards
        backgroundAnim.isRemovedOnCompletion = false
        self.layer.add(backgroundAnim, forKey: "showup_backround")
        
        
        // Text animation
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.fromValue = 0.0
        springAnimation.toValue = 1.0
        springAnimation.duration = duration
        springAnimation.damping = 9.0
        springAnimation.initialVelocity = 30.0
        springAnimation.mass = 0.5
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


#Preview {
    
    StartShakeMissionView()
}
