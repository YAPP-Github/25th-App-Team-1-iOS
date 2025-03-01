//
//  AlarmOptionButton.swift
//  FeatureAlarm
//
//  Created by ever on 1/22/25.
//

import UIKit
import SnapKit
import Then
import FeatureResources

final class AlarmOptionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize {
        return .init(width: 20, height: 20)
    }
    
    private let outerCircleView = UIView()
    private let innerCircleView = UIView()
    
    override var isSelected: Bool {
        didSet {
            updateButtonColor()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            updateButtonColor()
        }
    }
    
    private func updateButtonColor() {
        if isEnabled {
            outerCircleView.backgroundColor = isSelected ? R.Color.main30 : R.Color.gray600
            innerCircleView.backgroundColor = isSelected ? R.Color.main100 : R.Color.gray600
        } else {
            outerCircleView.backgroundColor = R.Color.gray700
            innerCircleView.backgroundColor = isSelected ? R.Color.gray600 : R.Color.gray700
        }
    }
    
    // 터치영역 확장
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let extendedBounds = self.bounds.insetBy(dx: -20, dy: -20) // 60x60 크기로 확장
        return extendedBounds.contains(point) ? self : nil
    }
}

private extension AlarmOptionButton {
    func setupUI() {
        outerCircleView.do {
            $0.backgroundColor = R.Color.gray600
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = false
        }
        
        innerCircleView.do {
            $0.backgroundColor = R.Color.gray600
            $0.layer.cornerRadius = 6
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = false
        }
        
        
        outerCircleView.addSubview(innerCircleView)
        addSubview(outerCircleView)
    }
    
    func layout() {
        outerCircleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.size.equalTo(20)
        }
        innerCircleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(12)
        }
    }
}

