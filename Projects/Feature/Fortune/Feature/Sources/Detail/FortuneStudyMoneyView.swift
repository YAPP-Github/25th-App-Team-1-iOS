//
//  FortuneStudyMoneyView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

protocol FortuneStudyMoneyViewListener: AnyObject {
    func action(_ action: FortuneStudyMoneyView.Action)
}

final class FortuneStudyMoneyView: TouchDetectingView {
    enum Action {
        case prev
        case next
    }

    enum State {
        case fortune(Fortune)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentScrollView.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.lessThanOrEqualTo(paperContainer.frame.height - 40)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
    }
    
    weak var listener: FortuneStudyMoneyViewListener?
    
    func update(_ state: State) {
        switch state {
        case let .fortune(fortune):
            studyContentView.update(subject: "학업/직장운 \(fortune.studyCareerFortune.score)점")
            studyContentView.update(title: fortune.studyCareerFortune.title)
            studyContentView.update(content: fortune.studyCareerFortune.description)
            
            moneyContentView.update(subject: "재물운 \(fortune.wealthFortune.score)점")
            moneyContentView.update(title: fortune.wealthFortune.title)
            moneyContentView.update(content: fortune.wealthFortune.description)
        }
    }
    
    override func onTouchOut() {
        listener?.action(.next)
    }
    
    private let backgroundImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 2, totalCount: 6)
    private let decoImageView = UIImageView()
    private let bubbleView = SpeechBubbleView()
    private let titleLabel = UILabel()
    private let paperContainer = UIView()
    private let paperImageView = UIImageView()
    private let contentScrollView = ScrollStackView()
    private let contentStackView = UIStackView()
    private let studyContentView = TodayFortuneContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneStudy.image,
        subjectColor: R.Color.letterBlue2
    )
    private let moneyContentView = TodayFortuneContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneMoney.image,
        subjectColor: R.Color.letterBabyPink
    )
}

private extension FortuneStudyMoneyView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        backgroundImageView.do {
            $0.image = FeatureResourcesAsset.backgroundFortune.image
            $0.contentMode = .scaleAspectFill
        }
        bubbleView.do {
            $0.update(titleText: "오늘의 운세")
            $0.update(arrowHidden: true)
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        decoImageView.do {
            $0.image = FeatureResourcesAsset.imgDecoFortune.image
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            $0.displayText = """
            오늘 너의 하루는 
            행운이 가득해!
            """.displayText(font: .ownglyphPHD_H2, color: R.Color.white100, alignment: .center)
            $0.numberOfLines = 0
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        paperImageView.do {
            $0.image = FeatureResourcesAsset.imgPaperContainerWithoutStar.image
            $0.contentMode = .scaleToFill
        }
        
        contentScrollView.do {
            $0.showsVerticalScrollIndicator = false
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 32
            $0.isUserInteractionEnabled = false
        }
        [backgroundImageView, pageIndicatorView, decoImageView, bubbleView, titleLabel, paperContainer].forEach {
            addSubview($0)
        }
        [paperImageView, contentScrollView].forEach {
            paperContainer.addSubview($0)
        }
        contentScrollView.addArrangedSubview(contentStackView)
        [studyContentView, moneyContentView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        paperContainer.setContentHuggingPriority(.required, for: .vertical)
    }
    func layout() {
        backgroundImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        pageIndicatorView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        decoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
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
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().offset(-32)
        }
        
        paperImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
