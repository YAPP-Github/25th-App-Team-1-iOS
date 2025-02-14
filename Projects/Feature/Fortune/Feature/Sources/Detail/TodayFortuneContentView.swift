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
    private let titleColor: UIColor
    
    init(icon: UIImage, titleColor: UIColor) {
        self.icon = icon
        self.titleColor = titleColor
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String) {
        titleLabel.displayText = title.displayText(font: .heading2SemiBold, color: titleColor)
    }
    
    func update(content: String) {
        contentLabel.displayText = content.displayText(font: .body2Regular, color: R.Color.gray600)
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
        contentLabel.do {
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
