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
    private let lottieView = LottieAnimationView()
    private let messageView = MessageView()
    private let stackView = UIStackView()
    
    // Messages
    private var timer: Timer?
    private let messages: [String] = [
        "미래에서 편지가 배송 중이에요",
        "잠시만 기다려 주세요!"
    ]
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        // self
        self.backgroundColor = R.Color.gray900.withAlphaComponent(0.8)
        
        // stackView
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .center
        addSubview(stackView)
        
        // messageView
        stackView.addArrangedSubview(messageView)
        messageView.update(text: "미래에서 편지가 배송중")
        
        // indicatorView
        lottieView.loopMode = .loop
        let lottileBundle = Bundle.resources
        let animFilePath = lottileBundle.path(forResource: "fortune_creation_loading", ofType: "json")!
        lottieView.animation = .filepath(animFilePath)
        stackView.addArrangedSubview(lottieView)
    }
    
    
    private func setupLayout() {
        // stackView
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        // indicatorView
        lottieView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(lottieView.snp.width).multipliedBy(0.7)
        }
    }
}


// MARK: Public inteface
extension FortuneLoadingView {
    func play() {
        lottieView.play()
        startTimer()
    }
    
    func stop() {
        lottieView.stop()
        stopTimer()
    }

    private func startTimer() {
        var index = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.messageView.update(text: self.messages[index])
            index = (index + 1) % self.messages.count
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    let view = FortuneLoadingView()
    view.play()
    return view
}
