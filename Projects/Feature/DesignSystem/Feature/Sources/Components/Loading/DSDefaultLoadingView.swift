//
//  DSDefaultLoadingView.swift
//  DesignSystem
//
//  Created by choijunios on 2/14/25.
//

import UIKit

import FeatureResources

import Lottie
import SnapKit

public final class DSDefaultLoadingView: UIView {
    // Sub view
    private let indicatorView = LottieAnimationView()
    
    public init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        // self
        self.backgroundColor = R.Color.gray900.withAlphaComponent(0.8)
        
        
        // indicatorView
        indicatorView.loopMode = .loop
        let lottileBundle = Bundle.resources
        let animFilePath = lottileBundle.path(forResource: "star_loading_motion", ofType: "json")!
        indicatorView.animation = .filepath(animFilePath)
        addSubview(indicatorView)
    }
    
    
    private func setupLayout() {
        // indicatorView
        indicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(70)
            make.center.equalToSuperview()
        }
    }
}


// MARK: Public inteface
public extension DSDefaultLoadingView {
    func play() {
        indicatorView.play()
    }
    
    func stop() {
        indicatorView.stop()
    }
}

#Preview {
    DSDefaultLoadingView()
}
