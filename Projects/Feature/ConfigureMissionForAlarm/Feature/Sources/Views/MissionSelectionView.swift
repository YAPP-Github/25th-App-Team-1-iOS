//
//  MissionSelectionView.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/21/25.
//

import UIKit

import FeatureUIDependencies

final class MissionSelectionView: UIView {
    
    // UI
    let titleLabel: UILabel = .init()
    
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func draw(_ rect: CGRect) {
        
        let radius: CGFloat = 16.0

        // 라운딩할 모서리 지정 (상단 좌우만)
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        // 클리핑과 색상 채우기
        R.Color.gray800.setFill()
        path.fill()
    }
}


// MARK: Setup
private extension MissionSelectionView {
    func setupUI() {
        
        // titleLabel
        titleLabel.displayText = "미션 선택".displayText(font: .heading2SemiBold, color: R.Color.white100)
        addSubview(titleLabel)
    }
    
    func setupLayout() {
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.left.equalToSuperview().inset(24)
        }
    }
}

