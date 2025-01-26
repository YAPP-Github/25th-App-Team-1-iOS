//
//  TagLabelView.swift
//  AlarmMission
//
//  Created by choijunios on 1/20/25.
//

import UIKit

import FeatureResources

import SnapKit

class TagLabelView: UIView {
    
    // Sub view
    private let titleLabel: UILabel = .init()
    
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.layer.bounds.height
        self.layer.cornerRadius = height/2
    }
    
    private func setupUI() {
        
        // self
        self.backgroundColor = R.Color.main10.withAlphaComponent(0.1)
        
        
        // titleLabel
        addSubview(titleLabel)
    }
    
    
    private func setupLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
}


// MARK: Public insterface
extension TagLabelView {
    
    func update(text: String) {
        self.titleLabel.displayText = text.displayText(
            font: .body2Medium,
            color: R.Color.main100
        )
    }
}


#Preview {
    let view = TagLabelView()
    view.update(text: "기상미션")
    return view
}
