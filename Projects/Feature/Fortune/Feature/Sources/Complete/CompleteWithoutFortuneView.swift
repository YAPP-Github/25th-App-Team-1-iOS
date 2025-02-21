//
//  CompleteWithFortuneView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import Lottie

protocol CompleteWithoutFortuneViewListener: AnyObject {
    func action(_ action: CompleteWithoutFortuneView.Action)
}

final class CompleteWithoutFortuneView: TouchDetectingView {
    enum Action {
        case prev
        case done
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
        characterImageView.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var listener: CompleteWithoutFortuneViewListener?
    
    override func onSwipeRight() {
        listener?.action(.prev)
    }
    
    private let decoImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 6, totalCount: 6)
    private let titleLabel = UILabel()
    private let hillImageView = UIImageView()
    private let characterImageView = LottieAnimationView()
    private let descriptionLabel = UILabel()
    private let doneButton = DSDefaultCTAButton()
    
    private let titles: [String] = [
        "운세는 여기까지야\n오늘 하루도 화이팅!",
        "좋은 아침!\n오늘도 운세처럼 잘 풀릴 거야!",
        "행운이 깃든 아침,\n하루가 더 특별해질 거야!",
        "오늘 운세는 여기까지야.\n이제 아침을 시작해보자!",
        "운세를 확인했으니,\n이제 일어나볼까?",
        "운세 확인 끝!\n이제 든든하게 하루 시작해봐"
    ]
}

private extension CompleteWithoutFortuneView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        decoImageView.do {
            $0.image = FeatureResourcesAsset.imgDecoFortune.image
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            if let randomTitle = titles.randomElement() {
                $0.displayText = randomTitle.displayText(font: .ownglyphPHD_H1, color: R.Color.white100)
            }
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        hillImageView.do {
            $0.image = FeatureResourcesAsset.imgFortuneHillSmall.image
            $0.contentMode = .scaleAspectFill
        }
        
        characterImageView.do {
            let lottileBundle = Bundle.resources
            let path =  lottileBundle.path(forResource: "fortune_without_reward", ofType: "json")!
            $0.contentMode = .scaleAspectFit
            $0.animation = .filepath(path)
            $0.loopMode = .loop
        }
        descriptionLabel.do {
            $0.displayText = "오늘의 운세는 하루 동안 홈 화면에서 볼 수 있어요.".displayText(font: .body2Regular, color: R.Color.white70)
            $0.textAlignment = .center
        }
        
        doneButton.do {
            $0.update(title: "완료")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.done)
            }
        }
        
        [decoImageView, pageIndicatorView, titleLabel, hillImageView, characterImageView, descriptionLabel, doneButton].forEach {
            addSubview($0)
        }
        
    }
    func layout() {
        decoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        pageIndicatorView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(pageIndicatorView.snp.bottom).offset(46)
            $0.centerX.equalToSuperview()
        }
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(95)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(220)
        }
        
        hillImageView.snp.makeConstraints {
            $0.top.equalTo(characterImageView).offset(136)
            $0.horizontalEdges.equalToSuperview()
        }
        doneButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
        }
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(doneButton.snp.top).offset(-18)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

