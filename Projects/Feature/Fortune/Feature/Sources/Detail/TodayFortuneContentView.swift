//
//  TodayFortuneContentView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

final class TodayFortuneContentView: UIView {
    private let icon: UIImage
    private let title: String
    private let titleColor: UIColor
    private let content: String
    
    init(icon: UIImage, title: String, titleColor: UIColor, content: String) {
        self.icon = icon
        self.title = title
        self.titleColor = titleColor
        self.content = content
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleStackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
}

private extension TodayFortuneContentView {
    func setupUI() {
        titleStackView.do {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalCentering
            $0.spacing = 4
        }
        iconImageView.do {
            $0.image = icon
            $0.contentMode = .scaleAspectFit
        }
        titleLabel.do {
            $0.displayText = title.displayText(font: .heading2SemiBold, color: titleColor)
        }
        contentLabel.do {
            $0.displayText = content.displayText(font: .body2Regular, color: R.Color.gray600)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        [iconImageView, titleLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        addSubview(titleStackView)
        addSubview(contentLabel)
        
    }
    func layout() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
