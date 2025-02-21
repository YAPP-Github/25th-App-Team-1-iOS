//
//  StartShakeMissionView.swift
//  AlarmMission
//
//  Created by choijunios on 1/21/25.
//

import UIKit

import FeatureUIDependencies

import FeatureThirdPartyDependencies

protocol StartShakeMissionViewListener: AnyObject {
    func action(_ action: StartShakeMissionView.Action)
}

final class StartShakeMissionView: UIView {
    
    enum Action {
        case shakeDetected
    }
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
        setShakeDetector()
    }
    required init?(coder: NSCoder) { nil }
    
    weak var listener: StartShakeMissionViewListener?
    private var shakeDetector: ShakeDetecter?
    
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
    
    private func setShakeDetector() {
        let shakeDetector = ShakeDetecter(shakeThreshold: 1.5, detectionInterval: 0.25) { [weak self] in
            self?.listener?.action(.shakeDetected)
            self?.shakeDetector = nil
        }
        self.shakeDetector = shakeDetector
        shakeDetector.startDetection()
    }
}


// MARK: Public interface
extension StartShakeMissionView {
    
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
    
    StartShakeMissionView()
}
