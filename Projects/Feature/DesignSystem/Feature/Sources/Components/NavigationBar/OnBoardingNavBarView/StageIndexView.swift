//
//  StageIndexView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import FeatureResources

import UIKit

final class StageIndexView: UIView {
    
    private let indexLabel: UILabel = .init()
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 54, height: 30)
    }
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    public func update(currentStage: Int, stageCount: Int) {
        // indexLabel
        indexLabel.displayText = "\(currentStage)/\(stageCount)"
            .displayText(font: .body1Medium, color: R.Color.gray200)
    }
    
    
    private func setupLayout() {
        
        // self
        backgroundColor = R.Color.gray700
        layer.cornerRadius = 10
        
        
        // indexLabel
        addSubview(indexLabel)
        indexLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}


#Preview {
    
    let view = StageIndexView()
    view.update(currentStage: 1, stageCount: 6)
    
    return view
}

