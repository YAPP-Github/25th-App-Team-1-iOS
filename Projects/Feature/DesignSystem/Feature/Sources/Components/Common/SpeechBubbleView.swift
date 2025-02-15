//
//  SpeechBubbleView.swift
//  FeatureDesignSystem
//
//  Created by ever on 2/8/25.
//

import UIKit
import FeatureResources
import SnapKit

public final class SpeechBubbleView: UIStackView {
    
    // Sub views
    private let bubbleView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let arrowView: UIImageView = .init()
    
    public init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    required init(coder: NSCoder) { fatalError() }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // bubbleView corner radius
        let bubbleViewHeight = bubbleView.layer.bounds.height
        bubbleView.layer.cornerRadius = bubbleViewHeight/2
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
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
        
        arrowView.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(8)
        }
    }
}


// MARK: Public interface
public extension SpeechBubbleView {
    
    func update(titleText: String) {
        titleLabel.displayText = titleText.displayText(
            font: .ownglyphPHD_H4,
            color: R.Color.white100
        )
    }
    
    func update(arrowHidden: Bool) {
        arrowView.isHidden = arrowHidden
    }
}


#Preview {
    let view = SpeechBubbleView()
    view.update(titleText: "안녕 나는 오르비야")
    return view
}
