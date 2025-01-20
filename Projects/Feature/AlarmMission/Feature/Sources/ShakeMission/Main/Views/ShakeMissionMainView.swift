//
//  ShakeMissionMainView.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureDesignSystem
import FeatureResources

import SnapKit

protocol ShakeMissionMainViewListener: AnyObject {
    
    func action(_ action: ShakeMissionMainView.Action)
}

class ShakeMissionMainView: UIView {
    
    // Action
    enum Action {
        
    }
    
    
    // Listener
    weak var listener: ShakeMissionMainViewListener?
    
    
    // Sub views
    
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
        
        backgroundLayer.frame = self.layer.bounds
    }
}


// MARK: Setup
private extension ShakeMissionMainView {
    
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
        
        
        //
    }
    
    func setupLayout() {
        
        // backgroundStars
        backgroundStar1.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(39)
            make.top.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        backgroundStar2.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).inset(82)
        }
        backgroundStar3.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(-2.5)
            make.top.equalTo(self.safeAreaLayoutGuide).inset(148)
        }
    }
}


#Preview {
    ShakeMissionMainView()
}
