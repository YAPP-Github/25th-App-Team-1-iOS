//
//  AuthorizationRequestView.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import UIKit
import SnapKit
import Then
import FeatureDesignSystem
import FeatureResources

protocol AuthorizationRequestViewListener: AnyObject {
    func action(_ action:AuthorizationRequestView.Action)
}

final class AuthorizationRequestView: UIView {
    enum Action {
        case backButtonTapped
        case yesButtonTapped
    }
    
    enum State {
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: AuthorizationRequestViewListener?

    private let navigationBar = OnBoardingNavBarView()
    private let titleLabel = UILabel()
    private let guideImageView = UIImageView()
    private let yesButton = DSDefaultCTAButton(initialState: .active)
}

private extension AuthorizationRequestView {
    func setupUI() {
        backgroundColor = R.Color.gray900
        navigationBar.do {
            $0.listener = self
            $0.setIndex(6, of: 6)
        }
        titleLabel.do {
            $0.displayText = """
            알람을 받으려면 꼭 필요해요
            다음 화면에서 ‘허용’을 눌러주세요
            """.displayText(font: .title3SemiBold, color: R.Color.white100)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        guideImageView.do {
            $0.image = FeatureResourcesAsset.svgOnboardingAuthorizationGuide.image
            $0.contentMode = .scaleAspectFit
        }
        
        yesButton.do {
            $0.update(title: "네, 알겠어요")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.yesButtonTapped)
            }
        }
        
        [navigationBar, titleLabel, guideImageView, yesButton].forEach {
            addSubview($0)
        }
    }
    
    func layout() {
        navigationBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        guideImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(100)
            $0.horizontalEdges.equalToSuperview().inset(33)
        }
        
        yesButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
    }
}

extension AuthorizationRequestView: OnBoardingNavBarViewListener {
    func action(_ action: OnBoardingNavBarView.Action) {
        switch action {
        case .backButtonClicked:
            listener?.action(.backButtonTapped)
        }
    }
}
