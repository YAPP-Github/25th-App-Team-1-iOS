//
//  ShakeMissionWorkingView.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureResources

protocol ShakeMissionWorkingViewListener: AnyObject {
    
    func action(_ action: ShakeMissionWorkingView.Action)
}

final class ShakeMissionWorkingView: UIView {
    
    // Action
    enum Action {
        
    }
    
    // Listener
    weak var listener: ShakeMissionWorkingViewListener?
    
    
    // Sub views
    private let exitButton: ExitButton = .init()
    private let missionProgressView: MissionProgressView = .init(percent: 0.0)
    private let amuletCardImage: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.shakeMissionWorkingAmulet.image
        $0.contentMode = .scaleAspectFit
    }
    
    // - Label
    private let labelStackView: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    private let titleLabel: UILabel = .init()
    private let shakeCountLabel: UILabel = .init()
    
    // - Background
    private var backgroundLayer: CAGradientLayer = .init()
    private let backgroundStar1: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.shakeMissionStar1.image
    }
    private let backgroundStar2: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.shakeMissionStar2.image
    }
    private let backgroundStar3: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.shakeMissionStar1.image
    }
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // backgroundLayer
        backgroundLayer.frame = self.layer.bounds
    }
}


// MARK: Setup
private extension ShakeMissionWorkingView {
    
    func setupUI() {
        
        // backgroundLayer
        backgroundLayer.colors = [
            UIColor(hex: "#1E3B68").cgColor,
            UIColor(hex: "#3F5F8D").cgColor,
        ]
        backgroundLayer.startPoint = .init(x: 0.5, y: 0.0)
        backgroundLayer.endPoint = .init(x: 0.5, y: 1.0)
        self.layer.addSublayer(backgroundLayer)
        
        
        // backgroundStars
        [backgroundStar1,backgroundStar2,backgroundStar3]
            .forEach({ self.addSubview($0) })
        
        
        // exitButton
        addSubview(exitButton)
        
        
        // missionProgressView
        addSubview(missionProgressView)
        
        
        // labelStackView
        [titleLabel,shakeCountLabel].forEach({labelStackView.addArrangedSubview($0)})
        addSubview(labelStackView)
        
        
        // amuletCardImage
        addSubview(amuletCardImage)
    }
    
    func setupLayout() {
        
        // backgroundStars
        backgroundStar1.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(39)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(103)
        }
        backgroundStar2.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(19.5)
        }
        backgroundStar3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(2.4)
            make.bottom.equalToSuperview().inset(6.8)
        }
        
        
        // exitButton
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(11)
            make.right.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        
        // missionProgressView
        missionProgressView.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(19)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        
        
        // labelStackView
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(missionProgressView.snp.bottom).offset(48)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
        }
        
        
        // amuletCardImage
        amuletCardImage.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        amuletCardImage.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        amuletCardImage.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(78)
            make.left.greaterThanOrEqualTo(self.safeAreaLayoutGuide).inset(92)
            make.right.lessThanOrEqualTo(self.safeAreaLayoutGuide).inset(92)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(self.safeAreaLayoutGuide).priority(.required)
        }
    }
}


// MARK: Shake amulet animation
private extension ShakeMissionWorkingView {
    
    func startShakeGuideAnim() {
        if amuletCardImage.layer.animation(forKey: "shake_guide") != nil &&
            amuletCardImage.layer.animation(forKey: "shake_guide_adjust") != nil { return }
        let guideAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        guideAnimation.values = [0,(CGFloat.pi/180)*10,0,0,-(CGFloat.pi/180)*10,0]
        guideAnimation.keyTimes = [0.1,0.2,0.4,0.5,0.65,1.0]
        guideAnimation.duration = 1.75
        guideAnimation.repeatCount = .infinity
        amuletCardImage.layer.add(guideAnimation, forKey: "shake_guide")
    }
    
    func stopShakeGuideAnim() {
        guard amuletCardImage.layer.animation(forKey: "shake_guide") != nil else { return }
        let currentTransform = amuletCardImage.layer.presentation()
        amuletCardImage.layer.removeAnimation(forKey: "shake_guide")
        amuletCardImage.layer.transform = currentTransform!.transform
        let adjustAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        adjustAnim.toValue = 0
        adjustAnim.duration = 0.5
        adjustAnim.fillMode = .forwards
        adjustAnim.isRemovedOnCompletion = false
        amuletCardImage.layer.add(adjustAnim, forKey: "shake_guide_adjust")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
            guard let self else { return }
            
            guard amuletCardImage.layer.animation(forKey: "shake_guide_adjust") != nil else { return }
            let currentTransform = amuletCardImage.layer.presentation()
            amuletCardImage.layer.removeAnimation(forKey: "shake_guide_adjust")
            amuletCardImage.layer.transform = currentTransform!.transform
        }
    }
}
