//
//  AuthorizationDeniedView.swift
//  FeatureOnboarding
//
//  Created by ever on 1/11/25.
//

import UIKit
import SnapKit
import Then
import FeatureDesignSystem
import FeatureResources

protocol AuthorizationDeniedViewListener: AnyObject {
    func action(_ action:AuthorizationDeniedView.Action)
}

final class AuthorizationDeniedView: UIView {
    enum Action {
        case backButtonTapped
        case laterButtonTapped
        case settingButtonTapped
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
    
    weak var listener: AuthorizationDeniedViewListener?
    
    private let navigationBar: OnBoardingNavBarView = .init()
    private let titleLabel = UILabel()
    private let deniedImageView = UIImageView()
    private let buttonStackView = UIStackView()
    private let laterButton = DSDefaultCTAButton(initialState: .active, style: .init(type: .secondary))
    private let settingButton = DSDefaultCTAButton(initialState: .active)
}

private extension AuthorizationDeniedView {
    func setupUI() {
        backgroundColor = R.Color.gray900
        navigationBar.do {
            $0.listener = self
        }
        titleLabel.do {
            $0.displayText = """
            알람을 허용하지 않으면 
            알림이 울리지 못해요
            """.displayText(font: .title3SemiBold, color: R.Color.white100)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        deniedImageView.do {
            $0.image = FeatureResourcesAsset.onboardingAuthorizationDenied.image
            $0.contentMode = .scaleAspectFit
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 12
        }
        
        laterButton.do {
            $0.update(title: "나중에 하기")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.laterButtonTapped)
            }
        }
        
        settingButton.do {
            $0.update(title: "설정 바로가기")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.settingButtonTapped)
            }
        }
        
        [navigationBar, titleLabel, deniedImageView, buttonStackView].forEach {
            addSubview($0)
        }
        [laterButton, settingButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
    }
    
    func layout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        deniedImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(66)
            $0.horizontalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
    }
}

extension AuthorizationDeniedView: OnBoardingNavBarViewListener {
    func action(_ action: OnBoardingNavBarView.Action) {
        switch action {
        case .backButtonClicked:
            listener?.action(.backButtonTapped)
        }
    }
}
