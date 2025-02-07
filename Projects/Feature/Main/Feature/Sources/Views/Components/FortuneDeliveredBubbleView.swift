//
//  FortuneDeliveredBubbleView.swift
//  Main
//
//  Created by choijunios on 1/28/25.
//

import UIKit

import FeatureResources

final class FortuneDeliveredBubbleView: UIView {
    
    // Sub view
    private let arrowView: UIImageView = .init()
    private let bubbleView: UIView = .init()
    private let titleLabel: UILabel = .init()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setupUI() {
        
        // arrowView
        arrowView.image = FeatureResourcesAsset.mainPageBubbleArrow.image
        addSubview(arrowView)
        
        
        // bubbleView
        addSubview(bubbleView)
        
        
        // titleLabel
        titleLabel.displayText = "운세 도착".displayText(
            font: .label2SemiBold,
            color: R.Color.gray100
        )
        bubbleView.layer.cornerRadius = 8
        bubbleView.layer.backgroundColor = R.Color.gray900.cgColor
        bubbleView.addSubview(titleLabel)
    }
    
    
    private func setupLayout() {
        // arrowView
        arrowView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        
        // bubbleView
        bubbleView.snp.makeConstraints { make in
            make.top.equalTo(arrowView.snp.bottom).offset(-0.335)
            make.centerX.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
        }
        
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.verticalEdges.equalToSuperview().inset(6)
        }
    }
}


#Preview {
    FortuneDeliveredBubbleView()
}
