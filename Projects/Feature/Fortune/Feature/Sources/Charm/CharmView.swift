//
//  CharmView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

final class CharmView: UIView {
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private let charmImageView = UIImageView()
    private let doneButton = DSDefaultCTAButton()
    private let shareButton = UIButton(type: .system)
}

private extension CharmView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        backgroundImageView.do {
            $0.image = FeatureResourcesAsset.imgBackgroundComplete.image
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            $0.displayText = """
            
            부적에 소원을 적으면
            이루어질거야!
            """.displayText(font: .ownglyphPHD_H1, color: R.Color.white100)
            $0.numberOfLines = 0
            $0.textAlignment = .left
        }
        
        charmImageView.do {
            $0.image = FeatureResourcesAsset.imgCharm.image
            $0.contentMode = .scaleAspectFit
        }
        
        doneButton.do {
            $0.update(title: "앨범에 저장")
        }
        
        shareButton.do {
            $0.semanticContentAttribute = .forceRightToLeft // 추후 수정 예정
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
            $0.setAttributedTitle("공유하기".displayText(font: .body1SemiBold, color: R.Color.white100), for: .normal)
            $0.setImage(FeatureResourcesAsset.svgIcoShare.image.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.tintColor = .white
        }
        
        [backgroundImageView, titleLabel, charmImageView, doneButton, shareButton].forEach {
            addSubview($0)
        }
        
    }
    func layout() {
        backgroundImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(30)
        }
        charmImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(37)
            $0.centerX.equalToSuperview()
        }
        shareButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-14)
        }
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(shareButton.snp.top).offset(-14)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

