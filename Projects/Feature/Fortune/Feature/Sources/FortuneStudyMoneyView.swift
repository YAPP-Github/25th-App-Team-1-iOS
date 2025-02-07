//
//  FortuneStudyMoneyView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

final class FortuneStudyMoneyView: UIView {
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 2, totalCount: 6)
    private let bubbleView = SpeechBubbleView()
    private let titleLabel = UILabel()
    private let paperContainer = UIImageView()
    private let contentStackView = UIStackView()
    private let studyContentView = TodayFortuneContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneStudy.image,
        title: "학업/직장운 88점",
        titleColor: R.Color.letterBlue2,
        content: """
        오늘은 집중력이 최고조야! 머릿속에 있는 생각들을 정리하고 효율적으로 공부하거나 업무에 집중하면 좋은 결과를 얻을 수 있을 거야. 복잡한 문제는 차근차근 풀어나가면 답을 찾을 수 있을 거야. 잠깐의 휴식도 잊지 말고 틈틈이 스트레칭을 하면서 긴장을 풀어주자!
        """
    )
    private let moneyContentView = TodayFortuneContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneMoney.image,
        title: "재물운 72점",
        titleColor: R.Color.letterBabyPink,
        content: """
        오늘은 투자보다는 안전한 자산 관리에 집중하는 게 좋아. 계획에 없던 지출은 피하고, 예산을 꼼꼼하게 관리하면 재정적으로 안정적인 하루를 보낼 수 있을 거야. 쓸데없는 소비를 줄여서 저축을 늘려보는 건 어때?
        """
    )
}

private extension FortuneStudyMoneyView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        backgroundImageView.do {
            $0.image = FeatureResourcesAsset.backgroundLetter.image
            $0.contentMode = .scaleAspectFill
        }
        bubbleView.do {
            $0.update(titleText: "오늘의 운세")
            $0.update(arrowHidden: true)
        }
        
        titleLabel.do {
            $0.displayText = """
            오늘의 운세
            오늘 너의 하루는 
            행운이 가득해!
            """.displayText(font: .ownglyphPHD_H2, color: R.Color.white100)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        paperContainer.do {
            $0.image = FeatureResourcesAsset.imgPaperContainerWithoutStar.image
            $0.contentMode = .scaleAspectFill
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 32
        }
        [backgroundImageView, pageIndicatorView, bubbleView, titleLabel, paperContainer].forEach {
            addSubview($0)
        }
        paperContainer.addSubview(contentStackView)
        [studyContentView, moneyContentView].forEach {
            contentStackView.addArrangedSubview($0)
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
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bubbleView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        paperContainer.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(32.5)
        }
        contentStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.verticalEdges.equalToSuperview().inset(30.5)
        }
    }
}
