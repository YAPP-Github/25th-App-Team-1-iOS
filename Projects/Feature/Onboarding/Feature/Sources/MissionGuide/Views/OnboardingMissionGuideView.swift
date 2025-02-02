//
//  OnboardingMissionGuideView.swift
//  FeatureOnboarding
//
//  Created by ever on 1/15/25.
//

import Lottie
import UIKit
import SnapKit
import Then
import FeatureResources
import FeatureDesignSystem

protocol OnboardingMissionGuideViewListener: AnyObject {
    func action(_ action: OnboardingMissionGuideView.Action)
}

final class OnboardingMissionGuideView: UIView {
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
    
    weak var listener: OnboardingMissionGuideViewListener?
    
    func playAnimation() {
        animationView.play()
    }
    
    private let welcomeLabel = UILabel()
    private let guideLabel = UILabel()
    private let animationView = LottieAnimationView(name: "onboarding_2", bundle: Bundle.resources)
    private let nextButton = DSDefaultCTAButton(initialState: .active)
}

private extension OnboardingMissionGuideView {
    func setupUI() {
        backgroundColor = R.Color.gray900
        
        welcomeLabel.do {
            $0.displayText = "환영해요!".displayText(font: .body2Regular, color: R.Color.main100)
        }
        
        guideLabel.do {
            $0.displayText = """
            기상 미션을 수행하면 
            운세를 확인 할 수 있어요
            """.displayText(font: .heading1SemiBold, color: R.Color.white100)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        animationView.do {
            $0.loopMode = .loop
            $0.animationSpeed = 1
            $0.contentMode = .scaleAspectFill
        }
        
        nextButton.do {
            $0.update(title: "다음")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.nextButtonTapped)
            }
        }
        
        [welcomeLabel, guideLabel, animationView, nextButton].forEach { addSubview($0) }
    }
    
    func layout() {
        welcomeLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(86)
            $0.centerX.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
}
