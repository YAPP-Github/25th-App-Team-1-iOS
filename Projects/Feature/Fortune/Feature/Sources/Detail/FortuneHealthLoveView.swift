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
        case fortune(Fortune, UserInfo)
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
        case let .fortune(fortune, userInfo):
            let name = userInfo.name
            switch fortune.avgFortuneScore {
            case 80...100:
                titleLabel.displayText = """
                오늘 \(name)의 하루는 
                누구보다 빛나!
                """.displayText(font: .ownglyphPHD_H2, color: R.Color.white100, alignment: .center)
            case 50...79:
                titleLabel.displayText = """
                오늘 \(name)의 하루는 
                최고야
                """.displayText(font: .ownglyphPHD_H2, color: R.Color.white100, alignment: .center)
            default:
                titleLabel.displayText = """
                오늘 \(name)의 하루는 
                주의가 필요해
                """.displayText(font: .ownglyphPHD_H2, color: R.Color.white100, alignment: .center)
            }
            
            healthContentView.update(subject: "건강운 \(fortune.healthFortune.score)점")
            healthContentView.update(title: fortune.healthFortune.title)
            healthContentView.update(content: fortune.healthFortune.description)
            
            loveContentView.update(subject: "애정운 \(fortune.loveFortune.score)점")
            loveContentView.update(title: fortune.loveFortune.title)
            loveContentView.update(content: fortune.loveFortune.description)
        }
    }
    
    override func onTap(direction: TouchDetectingView.TapDirection) {
        switch direction {
        case .left:
            listener?.action(.prev)
        case .right:
            listener?.action(.next)
        }
    }
    
    override func onSwipeLeft() {
        listener?.action(.next)
    }
    
    override func onSwipeRight() {
        listener?.action(.prev)
    }
    
    private let backgroundImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 3, totalCount: 6)
    private let decoImageView = UIImageView()
    private let bubbleView = SpeechBubbleView()
    private let titleLabel = UILabel()
    private let paperContainer = UIView()
    private let paperImageView = UIImageView()
    private let contentScrollView = ScrollStackView()
    private let contentStackView = UIStackView()
    private let healthContentView = TodayFortuneContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneHealth.image,
        subjectColor: R.Color.letterGreen
    )
    private let loveContentView = TodayFortuneContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneLove.image,
        subjectColor: R.Color.letterPink
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
            $0.numberOfLines = 0
            $0.textAlignment = .center
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
        }
        [backgroundImageView, pageIndicatorView, decoImageView, bubbleView, titleLabel, paperContainer].forEach {
            addSubview($0)
        }
        [paperImageView, contentScrollView].forEach {
            paperContainer.addSubview($0)
        }
        contentScrollView.tapped = { [weak self] in
            self?.listener?.action(.next)
        }
        contentScrollView.swipeLeft = { [weak self] in
            self?.listener?.action(.next)
        }
        contentScrollView.swipeRight = { [weak self] in
            self?.listener?.action(.prev)
        }
        contentScrollView.addArrangedSubview(contentStackView)
        [healthContentView, loveContentView].forEach {
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
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().offset(-32)
        }
        
        paperImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentScrollView.snp.remakeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.lessThanOrEqualToSuperview().offset(-40)
            $0.horizontalEdges.equalToSuperview().inset(28)
        }
    }
}
