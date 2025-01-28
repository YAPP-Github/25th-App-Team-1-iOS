//
//  SpeechBubbleView.swift
//  Main
//
//  Created by choijunios on 1/28/25.
//

import UIKit

import FeatureResources

import SnapKit

final class SpeechBubbleView: UIStackView {
    
    // Sub views
    private let bubbleView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let arrowView: UIImageView = .init()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // bubbleView corner radius
        let bubbleViewHeight = bubbleView.layer.bounds.height
        bubbleView.layer.cornerRadius = bubbleViewHeight/2
    }
}


// MARK: Setup
private extension SpeechBubbleView {
    
    func setupUI() {
        // self
        self.backgroundColor = .clear
        self.axis = .vertical
        self.alignment = .center
        self.spacing = 3
        
        
        // bubbleView
        bubbleView.backgroundColor = R.Color.white20
        addArrangedSubview(bubbleView)
        
        
        // titleLabel
        bubbleView.addSubview(titleLabel)
        
        
        // arrowView
        arrowView.image = FeatureResourcesAsset.speechBubbleArrow.image
        addArrangedSubview(arrowView)
    }
    
    
    func setupLayout() {
        
        // titleLabel
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}


// MARK: Public interface
extension SpeechBubbleView {
    
    func update(titleText: String) {
        titleLabel.displayText = titleText.displayText(
            font: .ownglyphPHD_H4,
            color: R.Color.white100
        )
    }
}


#Preview {
    let view = SpeechBubbleView()
    view.update(titleText: "안녕 나는 오르비야")
    return view
}
