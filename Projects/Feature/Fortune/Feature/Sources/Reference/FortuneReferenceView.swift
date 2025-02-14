//
//  FortuneReferenceView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

protocol FortuneReferenceViewListener: AnyObject {
    func action(_ action: FortuneReferenceView.Action)
}

final class FortuneReferenceView: TouchDetectingView {
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
    
    weak var listener: FortuneReferenceViewListener?
    
    func update(_ state: State) {
        switch state {
        case let .fortune(fortune):
            luckyColorContentView.update(content: fortune.luckyColor)
            luckyColorContentView.update(color: fortune.luckyCircleColor)
            avoidColorContentView.update(content: fortune.unluckyColor)
            avoidColorContentView.update(color: fortune.unluckyCircleColor)
            recommendFoodContentView.update(content: fortune.luckyFood)
            recommendFoodContentView.update(icon: FeatureResourcesAsset.svgIcoFortuneFood.image)
        }
    }
    
    override func onTap() {
        listener?.action(.next)
    }
    
    override func onSwipeLeft() {
        listener?.action(.next)
    }
    
    override func onSwipeRight() {
        listener?.action(.prev)
    }
    
    private let backgroundImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 5, totalCount: 6)
    private let decoImageView = UIImageView()
    private let bubbleView = SpeechBubbleView()
    private let titleLabel = UILabel()
    private let paperContainer = UIImageView()
    private let contentStackView = UIStackView()
    private let luckyColorContentView = FortuneReferenceContentView(title: "행운의 색")
    private let avoidColorContentView = FortuneReferenceContentView(title: "피해야 할 색")
    private let recommendFoodContentView = FortuneReferenceContentView(title: "추천 음식")
}

private extension FortuneReferenceView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        backgroundImageView.do {
            $0.image = FeatureResourcesAsset.backgroundFortune.image
            $0.contentMode = .scaleAspectFill
        }
        bubbleView.do {
            $0.update(titleText: "오늘 참고해")
            $0.update(arrowHidden: true)
        }
        decoImageView.do {
            $0.image = FeatureResourcesAsset.imgDecoFortune.image
            $0.contentMode = .scaleToFill
        }
        titleLabel.do {
            $0.displayText = """
            기억해놓고
            일상생활에 반영해 봐!
            """.displayText(font: .ownglyphPHD_H2, color: R.Color.white100)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        paperContainer.do {
            $0.image = FeatureResourcesAsset.imgPaperContainerWithoutStar.image
            $0.contentMode = .scaleToFill
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 52
        }
        [backgroundImageView, pageIndicatorView, decoImageView, bubbleView, titleLabel, paperContainer].forEach {
            addSubview($0)
        }
        paperContainer.addSubview(contentStackView)
        [luckyColorContentView, avoidColorContentView, recommendFoodContentView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
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
            $0.bottom.equalToSuperview().inset(32)
        }
        contentStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
