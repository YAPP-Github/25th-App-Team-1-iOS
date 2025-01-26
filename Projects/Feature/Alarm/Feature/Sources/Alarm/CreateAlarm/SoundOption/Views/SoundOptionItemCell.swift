//
//  SoundOptionItemCell.swift
//  FeatureAlarm
//
//  Created by ever on 1/27/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources
import FeatureDesignSystem

final class SoundOptionItemCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
    
    override var isSelected: Bool {
        didSet {
            optionButton.isSelected = isSelected
        }
    }
    
    // MARK: - Internal
    func configure(title: String, isSelected: Bool) {
        self.isSelected = isSelected
        titleLabel.displayText = title.displayText(font: .body1Medium, color: R.Color.white100)
    }
    
    private let optionButton = AlarmOptionButton()
    private let titleLabel = UILabel()
}

private extension SoundOptionItemCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        optionButton.do {
            $0.isUserInteractionEnabled = false
        }
        [optionButton, titleLabel].forEach { contentView.addSubview($0) }
    }
    
    func layout() {
        optionButton.snp.makeConstraints {
            $0.leading.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(optionButton.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
    }
}
