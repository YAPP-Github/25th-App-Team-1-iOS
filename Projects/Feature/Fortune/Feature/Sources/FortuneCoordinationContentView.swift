//
//  FortuneCoordinationContentView.swift
//  FeatureFortune
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureUIDependencies
import FeatureThirdPartyDependencies

final class FortuneCoordinationContentView: UIView {
    private let icon: UIImage
    private let title: String
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleContainer.layer.cornerRadius = titleContainer.frame.height / 2
    }
    
    private let stackView = UIStackView()
    private let iconImageView = UIImageView()
    private let titleContainer = UIView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
}

private extension FortuneCoordinationContentView {
    func setupUI() {
        iconImageView.do {
            $0.image = icon
            $0.contentMode = .scaleAspectFit
        }
        titleContainer.do {
            $0.backgroundColor = R.Color.gray50
            $0.layer.masksToBounds = true
        }
        titleLabel.do {
            $0.displayText = title.displayText(font: .label2SemiBold, color: R.Color.gray500)
        }
        contentLabel.do {
            $0.displayText = content.displayText(font: .body2Regular, color: R.Color.gray600)
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
        
        
        titleContainer.addSubview(titleLabel)
        [iconImageView, titleContainer, contentLabel].forEach {
            addSubview($0)
        }
    }
    func layout() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(28)
            $0.size.equalTo(54)
        }
        titleContainer.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(4)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleContainer.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

