//
//  CompleteWithFortuneView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

protocol CompleteWithFortuneViewListener: AnyObject {
    func action(_ action: CompleteWithFortuneView.Action)
}

final class CompleteWithFortuneView: UIView {
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
    
    weak var listener: CompleteWithFortuneViewListener?
    
    private let decoImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 6, totalCount: 6)
    private let titleLabel = UILabel()
    private let hillImageView = UIImageView()
    private let characterImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let doneButton = DSDefaultCTAButton()
}

private extension CompleteWithFortuneView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        decoImageView.do {
            $0.image = FeatureResourcesAsset.imgDecoFortune.image
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            $0.displayText = """
            첫 알람에 잘 일어났네!
            보상으로 행운 부적을 줄게
            """.displayText(font: .ownglyphPHD_H1, color: R.Color.white100)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        hillImageView.do {
            $0.image = FeatureResourcesAsset.imgFortuneHillSmall.image
            $0.contentMode = .scaleAspectFill
        }
        
        characterImageView.do {
            $0.image = FeatureResourcesAsset.imgCharacterHasFortune.image
            $0.contentMode = .scaleAspectFit
        }
        descriptionLabel.do {
            $0.displayText = "오늘의 운세는 하루 동안 홈 화면에서 볼 수 있어요.".displayText(font: .body2Regular, color: R.Color.white70)
            $0.textAlignment = .center
        }
        
        doneButton.do {
            $0.update(title: "부적 보러가기")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.next)
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
        doneButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-12)
        }
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalTo(doneButton.snp.top).offset(-18)
            $0.horizontalEdges.equalToSuperview()
        }
        characterImageView.snp.makeConstraints {
            $0.bottom.equalTo(descriptionLabel.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        hillImageView.snp.makeConstraints {
            $0.top.equalTo(characterImageView).offset(180)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

