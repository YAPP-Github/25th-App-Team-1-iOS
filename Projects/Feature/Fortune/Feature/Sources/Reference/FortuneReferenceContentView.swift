//
//  FortuneReferenceContentView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

final class FortuneReferenceContentView: UIView {
    private let title: String
    private let icon: UIImage
    private let content: String
    
    init(icon: UIImage, title: String, content: String) {
        self.icon = icon
        self.title = title
        self.content = content
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let iconImageView = UIImageView()
    private let contentStackView = UIStackView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
}

private extension FortuneReferenceContentView {
    func setupUI() {
        titleLabel.do {
            $0.displayText = title.displayText(font: .heading2SemiBold, color: R.Color.gray900)
        }
        contentStackView.do {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 12
        }
        iconImageView.do {
            $0.image = icon
            $0.contentMode = .scaleAspectFit
        }
        contentLabel.do {
            $0.displayText = content.displayText(font: .body1Regular, color: R.Color.gray600)
        }
        
        [iconImageView, contentLabel].forEach {
            contentStackView.addArrangedSubview($0)
        }
        addSubview(titleLabel)
        addSubview(contentStackView)
        
        
    }
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
