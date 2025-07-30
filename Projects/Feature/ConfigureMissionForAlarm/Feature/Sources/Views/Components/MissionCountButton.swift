//
//  MissionCountButton.swift
//  ConfigureMissionForAlarm
//
//  Created by choijunios on 7/30/25.
//

import UIKit

import FeatureUIDependencies

final class MissionCountButton: TouchDetectingView {
    
    // Action
    var buttonAction: (() -> ())?
    
    // UI
    private let containerStackView: UIStackView = .init()
    private let titleLabel: UILabel = .init()
    private let imageIconView: UIImageView = .init()
    
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    override func onTap(direction: TouchDetectingView.TapDirection) {
        self.buttonAction?()
    }
    
    
    override var intrinsicContentSize: CGSize {
        .init(
            width: UIView.noIntrinsicMetric,
            height: 20
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = bounds.height/2
    }
    
    private func setupUI() {
        // self
        self.isOpaque = false
        self.backgroundColor = R.Color.main10.withAlphaComponent(0.1)
        
        // titleLabel
        containerStackView.addArrangedSubview(titleLabel)
        
        // imageIconView
        containerStackView.addArrangedSubview(imageIconView)
        imageIconView.image = FeatureResourcesAsset.gnbRight.image
        imageIconView.tintColor = R.Color.main90
        
        // containerStackView
        addSubview(containerStackView)
        containerStackView.axis = .horizontal
        containerStackView.spacing = 0
    }
    
    private func setupLayout() {
        containerStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
        }
        
        imageIconView.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }
    }
    
    func update(title: String) {
        titleLabel.displayText = title.displayText(font: .label2regular, color: R.Color.main90)
    }
}

#Preview(traits: .defaultLayout, body: {
    let button = MissionCountButton()
    button.update(title: "15회")
    return button
})
