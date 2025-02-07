//
//  FortuneReferenceView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

protocol FortuneReferenceViewListener: AnyObject {
    func action(_ action: FortuneReferenceView.Action)
}

final class FortuneReferenceView: TouchDetectingView {
    enum Action {
        case prev
        case next
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
    
    override func onTouchOut() {
        listener?.action(.next)
    }
    
    private let backgroundImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 5, totalCount: 6)
    private let decoImageView = UIImageView()
    private let bubbleView = SpeechBubbleView()
    private let titleLabel = UILabel()
    private let paperContainer = UIImageView()
    private let contentStackView = UIStackView()
    private let luckyColorContentView = FortuneReferenceContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneColorGreen.image,
        title: "행운의 색",
        content: "초록색"
    )
    private let avoidColorContentView = FortuneReferenceContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneColorRed.image,
        title: "피해야 할 색",
        content: "빨간색"
    )
    private let recommendFoodContentView = FortuneReferenceContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneFood.image,
        title: "추천 음식",
        content: "햄버거"
    )
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
            $0.contentMode = .scaleAspectFill
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
            $0.contentMode = .scaleAspectFill
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
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
