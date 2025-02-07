//
//  AlarmPickerItemView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import UIKit

import FeatureResources

import FeatureThirdPartyDependencies

final class AlarmPickerItemView: UIView {
    
    // Sub view
    private let label: UILabel = .init()
    
    
    // View model
    let selectionItem: PickerSelectionItemable
    
    private var contentSize: CGSize?
    
    override var intrinsicContentSize: CGSize {
        return contentSize ?? super.intrinsicContentSize
    }
    
    init(item: PickerSelectionItemable) {
        self.selectionItem = item
        
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        self.backgroundColor = .clear
    }
    
    
    @discardableResult
    func setTextStyle(font: R.Font, color: UIColor) -> Self {
        
        label.displayText = selectionItem.displayingText
            .displayText(font: font, color: color)
        
        return self
    }
    
    
    @discardableResult
    func setContentSize(_ size: CGSize) -> Self {
        
        self.contentSize = size
        
        return self
    }
    
    
    private func setupLayout() {
        
        addSubview(label)
        label.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
        }
    }
}
