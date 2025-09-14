//
//  FortuneLoadingPageView.swift
//  Fortune
//
//  Created by choijunios on 9/14/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies
import FeatureCommonDependencies

enum FortuneLoadingPageViewUpdate {
    case startAnimating
    case stopAnimating
}

final class FortuneLoadingPageView: TouchDetectingView {
    init() {
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    required init?(coder: NSCoder) { nil }
    
    // background
    private let loadingView = FortuneLoadingView()
    private let cloudStarImageView = UIImageView()
    private let hillImageView = UIImageView()
    
    func update(_ update: FortuneLoadingPageViewUpdate) {
        switch update {
        case .startAnimating:
            loadingView.play()
        case .stopAnimating:
            loadingView.stop()
        }
    }
}

private extension FortuneLoadingPageView {
    func setupUI() {
        backgroundColor = .init(red: 72/255, green: 145/255, blue: 240/255, alpha: 1)
        
        addSubview(cloudStarImageView)
        addSubview(hillImageView)
        addSubview(loadingView)
        
        cloudStarImageView.do {
            $0.image = FeatureResourcesAsset.imgFortuneCloudStar.image
            $0.contentMode = .scaleAspectFill
        }
        
        hillImageView.do {
            $0.image = FeatureResourcesAsset.imgFortuneHillLarge.image
            $0.contentMode = .scaleAspectFill
        }
    }
    func layout() {
        cloudStarImageView.snp.makeConstraints {
            $0.top.equalTo(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        hillImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(250)
            $0.leading.trailing.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

#Preview {
    FortuneLoadingPageView()
}
