//
//  CompleteWithFortuneView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

protocol CompleteWithoutFortuneViewListener: AnyObject {
    func action(_ action: CompleteWithoutFortuneView.Action)
}

final class CompleteWithoutFortuneView: UIView {
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
    
    weak var listener: CompleteWithoutFortuneViewListener?
    
    private let backgroundImageView = UIImageView()
    private let pageIndicatorView = PageIndicatorView(activeCount: 6, totalCount: 6)
    private let titleLabel = UILabel()
    private let characterImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let doneButton = DSDefaultCTAButton()
}

private extension CompleteWithoutFortuneView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        backgroundImageView.do {
            $0.image = FeatureResourcesAsset.imgBackgroundComplete.image
            $0.contentMode = .scaleAspectFill
        }
        titleLabel.do {
            $0.displayText = """
            운세 확인 끝!
            이제 든든하게 하루 시작해봐
            """.displayText(font: .ownglyphPHD_H2, color: R.Color.white100)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        characterImageView.do {
            $0.image = FeatureResourcesAsset.imgCharacterNoFortune.image
            $0.contentMode = .scaleAspectFit
        }
        descriptionLabel.do {
            $0.displayText = "오늘의 운세는 하루 동안 홈 화면에서 볼 수 있어요.".displayText(font: .body2Regular, color: R.Color.white70)
            $0.textAlignment = .center
        }
        
        doneButton.do {
            $0.update(title: "완료")
            $0.buttonAction = { [weak self] in
                self?.listener?.action(.next)
            }
        }
        
        [backgroundImageView, pageIndicatorView, titleLabel, characterImageView, descriptionLabel, doneButton].forEach {
            addSubview($0)
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
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(pageIndicatorView.snp.bottom).offset(46)
            $0.centerX.equalToSuperview()
        }
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(95)
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
    }
}

