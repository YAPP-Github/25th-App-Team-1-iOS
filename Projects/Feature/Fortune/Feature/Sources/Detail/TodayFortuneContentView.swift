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
    private let subjectColor: UIColor
    
    init(icon: UIImage, subjectColor: UIColor) {
        self.icon = icon
        self.subjectColor = subjectColor
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(subject: String) {
        subjectLabel.displayText = subject.displayText(font: .heading2SemiBold, color: subjectColor)
    }
    
    func update(title: String) {
        titleLabel.displayText = title.displayText(font: .body1Bold, color: R.Color.gray600, alignment: .center)
    }
    
    func update(content: String) {
        contentLabel.displayText = content.displayText(font: .body2Regular, color: R.Color.gray600, alignment: .center)
    }
    
    private let subjectStackView = UIStackView()
    private let iconImageView = UIImageView()
    private let subjectLabel = UILabel()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
}

private extension TodayFortuneContentView {
    func setupUI() {
        subjectStackView.do {
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
        }
        
        [iconImageView, subjectLabel].forEach {
            subjectStackView.addArrangedSubview($0)
        }
        addSubview(subjectStackView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        
    }
    func layout() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        subjectStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(subjectStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
