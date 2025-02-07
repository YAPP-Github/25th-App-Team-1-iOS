//
//  FortuneHealthLoveView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

protocol FortuneHealthLoveViewListener: AnyObject {
    func action(_ action: FortuneHealthLoveView.Action)
}

final class FortuneHealthLoveView: TouchDetectingView {
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
    
    weak var listener: FortuneHealthLoveViewListener?
    
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
        title: "건강운 95점",
        titleColor: R.Color.letterGreen,
        content: """
        오늘은 컨디션 최고! 몸이 가볍고 활력이 넘칠 거야. 평소보다 운동을 좀 더 해보거나, 건강한 음식을 챙겨 먹으면 더욱 좋을 거야. 충분한 수면으로 컨디션을 유지하는 것도 잊지 말고!
        """
    )
    private let loveContentView = TodayFortuneContentView(
        icon: FeatureResourcesAsset.svgIcoFortuneMoney.image,
        title: "애정운 67점",
        titleColor: R.Color.letterPink,
        content: """
        솔로라면 새로운 만남의 기회가 있을 수 있어. 적극적으로 다가가 보는 것도 좋을 것 같아! 커플이라면 서로의 마음을 확인하는 시간을 가져보는 건 어때? 작은 선물이나 편지를 통해 애정을 표현해보는 것도 좋은 방법일 거야.
        """
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
