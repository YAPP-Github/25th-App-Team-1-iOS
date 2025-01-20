//
//  ExitButton.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureResources
import FeatureDesignSystem

class ExitButton: TouchDetectingView {
    
    // Action
    var buttonAction: (() -> Void)?
    
    
    // Sub view
    private let xMarkImage: UIImageView = .init().then {
        $0.image = FeatureResourcesAsset.xmark.image
        $0.contentMode = .scaleAspectFit
    }
    private let titleLabel: UILabel = .init().then {
        $0.displayText = "나가기".displayText(
            font: .body1SemiBold, color: R.Color.white100
        )
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func onTouchOut() { buttonAction?() }
}


// MARK: Setup
private extension ExitButton {
    
    func setupUI() {
        
        // xMarkImage
        addSubview(xMarkImage)
        
        
        // titleLabel
        addSubview(titleLabel)
    }
    
    func setupLayout() {
        
        // xMarkImage
        xMarkImage.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(3)
            make.bottom.lessThanOrEqualToSuperview().inset(3)
            make.left.equalToSuperview()
            make.right.equalTo(titleLabel.snp.left).offset(-4)
        }
        
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}


#Preview {
    ExitButton()
}
