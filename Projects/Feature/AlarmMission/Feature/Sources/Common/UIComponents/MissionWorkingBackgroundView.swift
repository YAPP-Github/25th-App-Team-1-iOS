//
//  MissionWorkingBackgroundView.swift
//  AlarmMission
//
//  Created by choijunios on 3/4/25.
//

import UIKit

import FeatureResources

final class MissionWorkingBackgroundView: UIView {
    // Sub views
    private var gradientLayer: CAGradientLayer = .init()
    private let backgroundStar1: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.missionBackgroundStar1.image
    }
    private let backgroundStar2: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.missionBackgroundStar2.image
    }
    private let backgroundStar3: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.missionBackgroundStar1.image
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.layer.bounds
    }
    
    private func setupUI() {
        // backgroundLayer
        gradientLayer.colors = [
            UIColor(hex: "#1E3B68").cgColor,
            UIColor(hex: "#3F5F8D").cgColor,
        ]
        gradientLayer.startPoint = .init(x: 0.5, y: 0.0)
        gradientLayer.endPoint = .init(x: 0.5, y: 1.0)
        self.layer.addSublayer(gradientLayer)
        
        
        // backgroundStars
        [backgroundStar1,backgroundStar2,backgroundStar3]
            .forEach(addSubview)
    }
    
    private func setupLayout() {
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
    }
}
