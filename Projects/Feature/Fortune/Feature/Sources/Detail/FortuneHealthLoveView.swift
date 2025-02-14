//
//  FortuneHealthLoveView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

protocol FortuneHealthLoveViewListener: AnyObject {
    func action(_ action: FortuneHealthLoveView.Action)
}

final class FortuneHealthLoveView: TouchDetectingView {
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
    
    weak var listener: FortuneHealthLoveViewListener?
    
    func update(_ state: State) {
        switch state {
        case let .fortune(fortune):
            healthContentView.update(title: "건강운 \(fortune.healthFortune.score)점")
            healthContentView.update(content: fortune.healthFortune.description)
            
            loveContentView.update(title: "애정운 \(fortune.loveFortune.score)점")
            loveContentView.update(content: fortune.loveFortune.description)
        }
    }
    
    override func onTouchOut() {
        listener?.action(.next)
    }
    
    private let backgroundImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 3, totalCount: 6)
    private let decoImageView = UIImageView()
    private let bubbleView = SpeechBubbleView()
    private let titleLabel = UILabel()
    private let paperContainer = UIImageView()
    private let contentStackView = UIStackView()
    private let healthContentView = TodayFortuneContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneStudy.image,
        titleColor: R.Color.letterGreen
    )
    private let loveContentView = TodayFortuneContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneMoney.image,
        titleColor: R.Color.letterPink
    )
}

private extension FortuneHealthLoveView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        backgroundImageView.do {
            $0.image = FeatureResourcesAsset.backgroundFortune.image
            $0.contentMode = .scaleAspectFill
        }
        bubbleView.do {
            $0.update(titleText: "오늘의 운세")
            $0.update(arrowHidden: true)
        }
        decoImageView.do {
            $0.image = FeatureResourcesAsset.imgDecoFortune.image
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            $0.displayText = """
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
        [backgroundImageView, pageIndicatorView, decoImageView, bubbleView, titleLabel, paperContainer].forEach {
            addSubview($0)
        }
        paperContainer.addSubview(contentStackView)
        [healthContentView, loveContentView].forEach {
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
            $0.horizontalEdges.equalToSuperview().inset(32.5)
        }
        contentStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.centerY.equalToSuperview()
        }
    }
}
