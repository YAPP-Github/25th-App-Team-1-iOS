//
//  EmptyAlarmView.swift
//  FeatureMain
//
//  Created by ever on 2/7/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

protocol EmptyAlarmViewListener: AnyObject {
    func action(_ action: EmptyAlarmView.Action)
}

final class EmptyAlarmView: UIView {
    enum Action {
        case fortuneNotiButtonTapped
        case applicationSettingButtonTapped
        case addAlarmButtonTapped
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: EmptyAlarmViewListener?
    
    private let fortuneNotiButton: DSDefaultIconButton = .init(style: .init(
        type: .default,
        image: FeatureResourcesAsset.letter.image,
        size: .small
    ))
    private let applicationSettingButton: DSDefaultIconButton = .init(style: .init(
        type: .default,
        image: FeatureResourcesAsset.settingsFill.image,
        size: .small
    ))
    
    private let mainEmptyAlarmImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let addAlarmButton = DSDefaultCTAButton()
}

private extension EmptyAlarmView {
    func setupUI() {
        backgroundColor = R.Color.gray800
        
        fortuneNotiButton.do {
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.fortuneNotiButtonTapped)
            }
        }
        
        applicationSettingButton.do {
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.applicationSettingButtonTapped)
            }
        }
        
        mainEmptyAlarmImageView.do {
            $0.image = FeatureResourcesAsset.mainEmptyAlarm.image
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.displayText = "기상 알람이 없어요".displayText(font: .heading1SemiBold, color: R.Color.white100)
        }
        
        addAlarmButton.do {
            $0.update(leftImage: FeatureResourcesAsset.svgPlus.image)
            $0.update(title: "새 알람 추가하기")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.addAlarmButtonTapped)
            }
        }
        
        subtitleLabel.do {
            $0.displayText = """
            알람을 추가하고 
            운세 편지를 받아보세요
            """.displayText(font: .body1Regular, color: R.Color.gray300)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        [fortuneNotiButton, applicationSettingButton, mainEmptyAlarmImageView, titleLabel, subtitleLabel, addAlarmButton].forEach {
            addSubview($0)
        }
    }
    func layout() {
        applicationSettingButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12.5)
            $0.trailing.equalTo(-12.5)
        }
        fortuneNotiButton.snp.makeConstraints {
            $0.trailing.equalTo(applicationSettingButton.snp.leading).offset(-12)
            $0.centerY.equalTo(applicationSettingButton)
        }
        mainEmptyAlarmImageView.snp.makeConstraints {
            $0.top.equalTo(applicationSettingButton.snp.bottom).offset(58.5)
            $0.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mainEmptyAlarmImageView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        addAlarmButton.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            $0.width.equalTo(203)
            $0.centerX.equalToSuperview()
        }
    }
}
