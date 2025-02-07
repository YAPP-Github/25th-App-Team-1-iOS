//
//  FortuneLetterView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

final class FortuneLetterView: UIView {
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 1, totalCount: 6)
    private let bubbleView = SpeechBubbleView()
    private let characterImageView = UIImageView()
    private let paperContainer = UIImageView()
    private let letterContentLabel = UILabel()
    private let fromLabel = UILabel()
}

private extension FortuneLetterView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        backgroundImageView.do {
            $0.image = FeatureResourcesAsset.backgroundLetter.image
            $0.contentMode = .scaleAspectFill
        }
        bubbleView.do {
            $0.update(titleText: "오늘 운세 점수 100점")
        }
        characterImageView.do {
            $0.image = FeatureResourcesAsset.fortuneCharacterHigh.image
            $0.contentMode = .scaleAspectFit
        }
        paperContainer.do {
            $0.image = FeatureResourcesAsset.imgPaperContainer.image
            $0.contentMode = .scaleAspectFill
        }
        letterContentLabel.do {
            $0.displayText = "민경,  오늘은 괜찮은 하루가 될 거야! 평소보다 긍정적인 마음으로 하루를 시작하면 좋은 일이 생길지도 몰라. 주변 사람들과의 관계에 신경 쓰면 더욱 행복한 하루가 될 거야. 혹시 오늘 중요한 일이 있다면, 미리 계획을 세우고 차분하게 진행하는 게 좋아. 너의 꼼꼼함이 빛을 발할 거야!".displayText(font: .ownglyphPHD_H3, color: R.Color.gray600)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        fromLabel.do {
            $0.displayText = "From. 오르비".displayText(font: .ownglyphPHD_H4, color: R.Color.gray600)
        }
        [backgroundImageView, pageIndicatorView, bubbleView, characterImageView, paperContainer].forEach {
            addSubview($0)
        }
        [letterContentLabel, fromLabel].forEach {
            paperContainer.addSubview($0)
        }
        
    }
    func layout() {
        backgroundImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        pageIndicatorView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        bubbleView.snp.makeConstraints {
            $0.top.equalTo(pageIndicatorView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(bubbleView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        paperContainer.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(32.5)
        }
        letterContentLabel.snp.makeConstraints {
            $0.top.equalTo(60)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        fromLabel.snp.makeConstraints {
            $0.top.equalTo(letterContentLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-60)
        }
    }
}
