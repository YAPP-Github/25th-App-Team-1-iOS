//
//  OnboardingFortuneGuideView.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import Lottie
import UIKit
import FeatureThirdPartyDependencies
import FeatureUIDependencies

protocol OnboardingFortuneGuideViewListener: AnyObject {
    func action(_ action: OnboardingFortuneGuideView.Action)
}

final class OnboardingFortuneGuideView: UIView {
    enum Action {
        case backButtonTapped
        case startButtonTapped
    }
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: OnboardingFortuneGuideViewListener?
    
    func playAnimation() {
        animationView.play()
    }
    
    private let navigationBar = OnBoardingNavBarView()
    private let welcomeLabel = UILabel()
    private let guideLabel = UILabel()
    private let animationView = LottieAnimationView(name: "onboarding_3", bundle: Bundle.resources)
    private let startButton = DSDefaultCTAButton(initialState: .active)
}

private extension OnboardingFortuneGuideView {
    func setupUI() {
        backgroundColor = R.Color.gray900
        navigationBar.do {
            $0.listener = self
        }
        welcomeLabel.do {
            $0.displayText = "환영해요!".displayText(font: .body2Regular, color: R.Color.main100)
        }
        
        guideLabel.do {
            $0.displayText = """
            오르비의 하루 운세로
            아침을 즐겁게 시작해 보세요!
            """.displayText(font: .heading1SemiBold, color: R.Color.white100)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        animationView.do {
            $0.loopMode = .loop
            $0.animationSpeed = 1.0
            $0.contentMode = .scaleAspectFill
        }
        
        startButton.do {
            $0.update(title: "시작하기")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.startButtonTapped)
            }
        }
        
        [animationView, navigationBar, welcomeLabel, guideLabel, startButton].forEach { addSubview($0) }
    }
    
    func layout() {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

extension OnboardingFortuneGuideView: OnBoardingNavBarViewListener {
    func action(_ action: OnBoardingNavBarView.Action) {
        switch action {
        case .backButtonClicked:
            listener?.action(.backButtonTapped)
        case .rightButtonClicked:
            break
        }
    }
}
