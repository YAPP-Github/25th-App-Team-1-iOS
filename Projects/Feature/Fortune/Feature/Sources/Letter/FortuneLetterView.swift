//
//  FortuneLetterView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

protocol FortuneLetterViewListener: AnyObject {
    func action(_ action: FortuneLetterView.Action)
}

final class FortuneLetterView: TouchDetectingView {
    enum Action {
        case next
    }
    
    enum State {
        case fortune(Fortune)
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
        playAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: FortuneLetterViewListener?
    
    private func playAnimation() {
        let animator1 = UIViewPropertyAnimator(duration: 1.0, curve: .easeIn) {
            self.bubbleView.alpha = 1
        }

        let animator2 = UIViewPropertyAnimator(duration: 0.6, curve: .easeIn) {
            self.paperContainer.alpha = 1
        }

        let animator3 = UIViewPropertyAnimator(duration: 0.6, curve: .easeIn) {
            self.contentScrollView.alpha = 1
        }
        
        animator1.addCompletion { _ in
            animator2.startAnimation()
            animator2.addCompletion { _ in
                animator3.startAnimation()
            }
        }

        animator1.startAnimation()
    }
    
    func update(_ state: State) {
        switch state {
        case let .fortune(fortune):
            bubbleView.update(titleText: "오늘 운세점수 \(fortune.avgFortuneScore)점")
            bubbleView.update(arrowHidden: false)
            letterTitleLabel.displayText = fortune.dailyFortuneTitle.displayText(font: .ownglyphPHD_H2, color: R.Color.gray600, alignment: .center)
            letterContentLabel.displayText = fortune.dailyFortuneDescription.displayText(font: .ownglyphPHD_H4, color: R.Color.gray500, alignment: .center)
            switch fortune.avgFortuneScore {
            case 80...100:
                characterImageView.image = FeatureResourcesAsset.fortuneCharacterHigh.image
            case 50...79:
                characterImageView.image = FeatureResourcesAsset.fortuneCharacterMiddle.image
            default:
                characterImageView.image = FeatureResourcesAsset.fortuneCharacterLow.image
            }
        }
    }
    
    override func onTap() {
        listener?.action(.next)
    }
    
    override func onSwipeLeft() {
        listener?.action(.next)
    }
    
    // background
    private let cloudStarImageView = UIImageView()
    private let hillImageView = UIImageView()
    
    private let pageIndicatorView = PageIndicatorView(activeCount: 1, totalCount: 6)
    private let bubbleView = SpeechBubbleView()
    private let characterImageView = UIImageView()
    // Letter
    private let paperContainer = UIView()
    private let starImageView = UIImageView()
    private let paperImageView = UIImageView()
    private let contentScrollView = ScrollStackView()
    
    private let letterStackView = UIStackView()
    private let letterTitleLabel = UILabel()
    private let letterContentLabel = UILabel()
    private let fromLabel = UILabel()
}

private extension FortuneLetterView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        cloudStarImageView.do {
            $0.image = FeatureResourcesAsset.imgFortuneCloudStar.image
            $0.contentMode = .scaleAspectFill
        }
        
        characterImageView.do {
            $0.image = FeatureResourcesAsset.fortuneCharacterHigh.image
            $0.contentMode = .scaleAspectFit
        }
        
        hillImageView.do {
            $0.image = FeatureResourcesAsset.imgFortuneHillLarge.image
            $0.contentMode = .scaleAspectFill
        }
        
        paperImageView.do {
            paperImageView.image = FeatureResourcesAsset.imgPaperContainerWithoutStar.image
            $0.contentMode = .scaleToFill
        }
        
        starImageView.do {
            $0.image = FeatureResourcesAsset.imgFortuneStar.image
            $0.contentMode = .scaleAspectFit
        }
        
        letterStackView.do {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 12
        }
        
        letterTitleLabel.do {
            $0.numberOfLines = 0
        }
        
        letterContentLabel.do {
            $0.numberOfLines = 0
        }
        
        fromLabel.do {
            $0.displayText = "From. 오르비".displayText(font: .ownglyphPHD_H5, color: R.Color.gray600, alignment: .center)
        }
        
        [letterTitleLabel, letterContentLabel, fromLabel].forEach {
            letterStackView.addArrangedSubview($0)
        }
        contentScrollView.tapped = { [weak self] in
            self?.listener?.action(.next)
        }
        contentScrollView.swipeLeft = { [weak self] in
            self?.listener?.action(.next)
        }
        contentScrollView.addArrangedSubview(letterStackView)
        
        [paperImageView, starImageView, contentScrollView].forEach {
            paperContainer.addSubview($0)
        }
        
        [cloudStarImageView, pageIndicatorView, bubbleView, hillImageView, characterImageView, paperContainer].forEach {
            addSubview($0)
        }
        
        [pageIndicatorView, characterImageView].forEach {
            $0.setContentHuggingPriority(.required, for: .vertical)
        }
        
        [characterImageView].forEach {
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        
        // 애니메이션을 위함
        [bubbleView, paperContainer, contentScrollView].forEach {
            $0.alpha = 0
        }
    }
    func layout() {
        cloudStarImageView.snp.makeConstraints {
            $0.top.equalTo(8)
            $0.horizontalEdges.equalToSuperview()
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
            $0.size.equalTo(160)
        }
        hillImageView.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(-50)
            $0.leading.trailing.equalToSuperview()
        }
        
        paperContainer.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(25.5)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        paperImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        starImageView.snp.makeConstraints {
            $0.top.equalTo(paperContainer).offset(-21)
            $0.leading.equalTo(paperContainer).offset(21)
        }
        
        letterStackView.snp.makeConstraints {
            $0.width.equalTo(267)
        }
        
        contentScrollView.snp.remakeConstraints {
            $0.center.equalToSuperview()
            $0.height.lessThanOrEqualToSuperview().offset(-40)
        }
    }
}
