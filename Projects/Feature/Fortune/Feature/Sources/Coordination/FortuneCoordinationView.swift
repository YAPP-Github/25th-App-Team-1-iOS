//
//  FortuneCoordinationView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

protocol FortuneCoordinationViewListener: AnyObject {
    func action(_ action: FortuneCoordinationView.Action)
}

final class FortuneCoordinationView: TouchDetectingView {
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
    
    weak var listener: FortuneCoordinationViewListener?
    
    func update(_ state: State) {
        switch state {
        case let .fortune(fortune):
            topClothContentView.update(content: fortune.luckyOutfitTop)
            bottomClothContentView.update(content: fortune.luckyOutfitBottom)
            shoesContentView.update(content: fortune.luckyOutfitShoes)
            accessoryClothContentView.update(content: fortune.luckyOutfitAccessory)
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
    private let pageIndicatorView = PageIndicatorView(activeCount: 4, totalCount: 6)
    private let decoImageView = UIImageView()
    private let bubbleView = SpeechBubbleView()
    private let titleLabel = UILabel()
    private let paperContainer = UIImageView()
    private let contentStackView = UIStackView()
    private let topBottomClothStackView = UIStackView()
    private let topClothContentView = FortuneCoordinationContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneClothTop.image,
        title: "상의"
    )
    private let bottomClothContentView = FortuneCoordinationContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneClothBottom.image,
        title: "하의"
    )
    
    private let shoesAccessoryStackView = UIStackView()
    
    private let shoesContentView = FortuneCoordinationContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneShoes.image,
        title: "신발"
    )
    private let accessoryClothContentView = FortuneCoordinationContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneAccessory.image,
        title: "액세서리"
    )
}

private extension FortuneCoordinationView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        backgroundImageView.do {
            $0.image = FeatureResourcesAsset.backgroundFortune.image
            $0.contentMode = .scaleAspectFill
        }
        bubbleView.do {
            $0.update(titleText: "오늘의 코디")
            $0.update(arrowHidden: true)
        }
        decoImageView.do {
            $0.image = FeatureResourcesAsset.imgDecoFortune.image
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            $0.displayText = """
            오늘은 이렇게 입는 거 어때?
            코디에 참고해봐!
            """.displayText(font: .ownglyphPHD_H2, color: R.Color.white100)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        paperContainer.do {
            $0.image = FeatureResourcesAsset.imgPaperContainerWithoutStar.image
            $0.contentMode = .scaleToFill
        }
        
        topBottomClothStackView.do {
            $0.axis = .horizontal
            $0.alignment = .top
            $0.distribution = .fill
            $0.spacing = 24
        }
        
        shoesAccessoryStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 24
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
        [topClothContentView, bottomClothContentView].forEach {
            topBottomClothStackView.addArrangedSubview($0)
        }
        [shoesContentView, accessoryClothContentView].forEach {
            shoesAccessoryStackView.addArrangedSubview($0)
        }
        [topBottomClothStackView, shoesAccessoryStackView].forEach {
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
            $0.center.equalToSuperview()
        }
    }
}

