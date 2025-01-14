//
//  OnboardingIntroView.swift
//  FeatureOnboarding
//
//  Created by ever on 1/14/25.
//

import Lottie
import UIKit
import SnapKit
import Then
import FeatureResources
import FeatureDesignSystem

protocol OnboardingIntroViewListener: AnyObject {
    func action(_ action: OnboardingIntroView.Action)
}

final class OnboardingIntroView: UIView {
    enum Action {
        case nextButtonTapped
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: OnboardingIntroViewListener?
    
    func playAnimation() {
        animationView.play()
    }
    
    private let animationView = LottieAnimationView(name: "onboarding_1", bundle: Bundle.resources)
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let nextButton = DSDefaultCTAButton(initialState: .active)
}

private extension OnboardingIntroView {
    func setupUI() {
        self.backgroundColor = R.Color.gray900
        titleLabel.do {
            $0.displayText = "운세 기반 기상 알람 서비스".displayText(font: .body1Regular, color: R.Color.gray100)
            $0.textAlignment = .center
        }
        
        subtitleLabel.do {
            $0.displayText = """
            "오르비 알람은 기상과 함께
            하루 운세를 제공해요
            """.displayText(font: .heading1SemiBold, color: R.Color.white100)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        animationView.do {
            $0.loopMode = .loop
            $0.animationSpeed = 0.5
            $0.contentMode = .scaleAspectFit
        }
        
        nextButton.do {
            $0.update(title: "다음")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.nextButtonTapped)
            }
        }
        
        [animationView, titleLabel, subtitleLabel, nextButton].forEach { addSubview($0) }
    }
    
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(86)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(123)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
