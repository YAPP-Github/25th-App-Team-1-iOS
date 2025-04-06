//
//  AlarmDeleteButton.swift
//  Main
//
//  Created by choijunios on 2/1/25.
//

import UIKit

import FeatureResources
import FeatureDesignSystem

import SnapKit

final class AlarmDeleteButton: TouchDetectingView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    private let trashImage: UIImageView = .init()
    private let contentStack: UIStackView = .init().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
    }
    
    
    // button action
    var buttonAction: (() -> Void)?
    
    
    override var intrinsicContentSize: CGSize {
        .init(width: 120, height: UIView.noIntrinsicMetric)
    }
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setupUI() {
        // self
        self.backgroundColor = R.Color.gray700
        self.layer.cornerRadius = 12
        
        // titleLabel
        titleLabel.displayText = "삭제".displayText(
            font: .body1SemiBold,
            color: R.Color.statusAlert
        )
        
        // trashImage
        trashImage.image = FeatureResourcesAsset.trashFill.image
        trashImage.contentMode = .scaleAspectFit
        trashImage.tintColor = R.Color.statusAlert
        
        // contentStack
        [titleLabel, UIView(), trashImage].forEach {
            contentStack.addArrangedSubview($0)
        }
        addSubview(contentStack)
    }
    
    private func setupLayout() {
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(14)
            make.verticalEdges.equalToSuperview().inset(8)
        }
    }
    
    override func onTouchIn() {
        self.backgroundColor = R.Color.gray600
        titleLabel.displayText = titleLabel.displayText?.string.displayText(
            font: .body1SemiBold,
            color: R.Color.statusAlert50.withAlphaComponent(0.5)
        )
        trashImage.tintColor = R.Color.statusAlert50.withAlphaComponent(0.5)
    }
    override func onTouchOut(isInbound: Bool?) {
        self.backgroundColor = R.Color.gray700
        titleLabel.displayText = titleLabel.displayText?.string.displayText(
            font: .body1SemiBold,
            color: R.Color.statusAlert
        )
        trashImage.tintColor = R.Color.statusAlert
    }
    
    override func onTap(direction: TouchDetectingView.TapDirection) { buttonAction?() }
}

#Preview {
    AlarmDeleteButton()
}
