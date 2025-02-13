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
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(icon: UIImage) {
        iconImageView.image = icon
        iconImageView.isHidden = false
        colorView.isHidden = true
    }
    
    
    func update(color: UIColor) {
        colorView.backgroundColor = color
        colorView.isHidden = false
        iconImageView.isHidden = true
    }
    
    func update(content: String) {
        contentLabel.displayText = content.displayText(font: .body1Regular, color: R.Color.gray600)
    }
    
    private let iconImageView = UIImageView()
    private let colorView = UIView()
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
        colorView.do {
            $0.layer.cornerRadius = 10
            $0.layer.cornerCurve = .circular
        }
        
        iconImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        [iconImageView, colorView, contentLabel].forEach {
            contentStackView.addArrangedSubview($0)
        }
        addSubview(titleLabel)
        addSubview(contentStackView)
        
        
    }
    func layout() {
        colorView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
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
