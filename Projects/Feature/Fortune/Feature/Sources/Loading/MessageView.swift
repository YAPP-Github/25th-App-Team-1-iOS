//
//  MessageView.swift
//  Fortune
//
//  Created by choijunios on 9/14/25.
//

import UIKit
import FeatureResources

final class MessageView: UIView {
    
    private let label: UILabel = .init()
    private let labelCotainerView: UIView = .init()
    private let stackView = UIStackView()
    private let arrowImageView: UIImageView = .init()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    private func setupUI() {
        label.numberOfLines = 1
        labelCotainerView.addSubview(label)
        
        labelCotainerView.backgroundColor = R.Color.white20.withAlphaComponent(0.2)
        labelCotainerView.layer.cornerRadius = 35 / 2
        stackView.addArrangedSubview(labelCotainerView)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 3
        addSubview(stackView)
        
        arrowImageView.image = FeatureResourcesAsset.messageDownArrow.image
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = R.Color.white20.withAlphaComponent(0.2)
        stackView.addArrangedSubview(arrowImageView)
    }
    
    private func setupLayout() {
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        labelCotainerView.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.height.equalTo(8)
        }
    }
    
    func update(text: String) {
        label.displayText = text.displayText(font: .ownglyphPHD_H4)
    }
}

#Preview(traits: .defaultLayout, body: {
    let v = MessageView()
    v.update(text: "Hello world")
    return v
})

