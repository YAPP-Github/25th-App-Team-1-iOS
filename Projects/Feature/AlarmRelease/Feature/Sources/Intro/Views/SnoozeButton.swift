//
//  SnoozeButton.swift
//  FeatureAlarmRelease
//
//  Created by ever on 2/11/25.
//

import UIKit
import FeatureCommonDependencies
import FeatureUIDependencies
import FeatureThirdPartyDependencies

final class SnoozeButton: UIButton {
    init(option: SnoozeOption) {
        self.option = option
        super.init(frame: .zero)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let containerSize = countContainer.frame.size
        let rightInset = 20 + containerSize.width
        layer.cornerRadius = frame.height / 2
        countContainer.layer.cornerRadius = countContainer.frame.height / 2
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -rightInset, bottom: 0, right: rightInset)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: rightInset + 20, bottom: 0, right: 0)
    }
    
    private let option: SnoozeOption
    private let countLabel = UILabel()
    private let countContainer = UIView()
}

private extension SnoozeButton {
    func setupUI() {
        let title = option.frequency.toKoreanFormat + " 미루기"
        let count = option.count.toKoreanTitleFormat
        backgroundColor = R.Color.white30
        layer.borderWidth = 1
        layer.borderColor = R.Color.white20.cgColor
        setAttributedTitle(title.displayText(font: .heading2SemiBold, color: R.Color.white100), for: .normal)
        countLabel.displayText = count.displayText(font: .body2Medium, color: R.Color.main100)
        countContainer.backgroundColor = R.Color.main30
        countContainer.addSubview(countLabel)
        addSubview(countContainer)
    }
    
    func layout() {
        countLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview().inset(6)
        }
        countContainer.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.trailing.equalTo(-12)
        }
    }
}
