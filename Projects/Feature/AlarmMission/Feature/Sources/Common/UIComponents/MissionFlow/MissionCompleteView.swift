//
//  MissionCompleteView.swift
//  AlarmMission
//
//  Created by choijunios on 1/22/25.
//

import UIKit

import FeatureUIDependencies

import FeatureThirdPartyDependencies
import Lottie
import RxSwift

final class MissionCompleteView: UIView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private var confettiAnimView: LottieAnimationView?
    
    
    // Rx
    private let disposeBag: DisposeBag = .init()
    
    
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
extension MissionCompleteView {
    @discardableResult
    func update(titleText: String) -> Self {
        titleLabel.displayText = titleText.displayText(
            font: .displayBold, color: R.Color.white100
        )
        return self
    }
    
    enum AnimationConfig {
        // Duration
        static let titleTextShowupDuration: Double = 0.5
    }
    
    
    // MARK: Animation
    func startShowUpAnimation(centeringView: UIView, completion: (()->Void)? = nil) {
        
        if titleLabel.layer.animation(forKey: "showup_title") != nil {
            titleLabel.layer.removeAnimation(forKey: "showup_title")
        }
        
        // Set label layout
        var centeringViewFrameInSelf = self.convert(centeringView.bounds, from: centeringView)
        let labelSize = titleLabel.intrinsicContentSize
        centeringViewFrameInSelf.origin.x += (centeringView.bounds.width/2-labelSize.width/2)
        centeringViewFrameInSelf.origin.y += (centeringView.bounds.height/2-labelSize.height/2)
        titleLabel.frame = .init(
            origin: centeringViewFrameInSelf.origin,
            size: labelSize
        )
        
        
        // Complete subject
        let titleTextShowupCompleted = PublishSubject<Void>()
        let confettiLottieCompleted = PublishSubject<Void>()
        
        
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
        let duration = AnimationConfig.titleTextShowupDuration
        DispatchQueue.main.asyncAfter(deadline: .now()+duration) {
            titleTextShowupCompleted.onNext(())
        }
        
        
        // Confetti lottie
        let lottieView = createConfettiLottieView()
        addSubview(lottieView)
        lottieView.snp.makeConstraints { make in
            make.center.equalTo(titleLabel).priority(.high)
            make.horizontalEdges.equalToSuperview().priority(.high)
            make.height.equalTo(lottieView.snp.width).priority(.medium)
        }
        lottieView.play { _ in confettiLottieCompleted.onNext(()) }
        
        
        Observable
            .zip(titleTextShowupCompleted, confettiLottieCompleted)
            .take(1)
            .subscribe(onNext: { _ in
                completion?()
            })
            .disposed(by: disposeBag)
    }
    
    private func createConfettiLottieView() -> LottieAnimationView {
        
        guard let path = Bundle.resources.path(forResource: "shakemissionconfetti", ofType: "json") else { fatalError() }
        let confettiAnimView = LottieAnimationView(filePath: path)
        confettiAnimView.contentMode = .scaleAspectFit
        confettiAnimView.loopMode = .playOnce
        confettiAnimView.animationSpeed = 1
        return confettiAnimView
    }
    
}
