//
//  FortuneLoadingView.swift
//  Fortune
//
//  Created by choijunios on 9/14/25.
//

import UIKit

import FeatureResources

import Lottie
import SnapKit

final class FortuneLoadingView: UIView {
    // Sub view
    private let indicatorView = LottieAnimationView()
    
    init() {
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
        let animFilePath = lottileBundle.path(forResource: "fortune_creation_loading", ofType: "json")!
        indicatorView.animation = .filepath(animFilePath)
        addSubview(indicatorView)
    }
    
    
    private func setupLayout() {
        // indicatorView
        indicatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}


// MARK: Public inteface
extension FortuneLoadingView {
    func play() {
        indicatorView.play()
    }
    
    func stop() {
        indicatorView.stop()
    }
}

#Preview {
    let view = FortuneLoadingView()
    view.play()
    return view
}
