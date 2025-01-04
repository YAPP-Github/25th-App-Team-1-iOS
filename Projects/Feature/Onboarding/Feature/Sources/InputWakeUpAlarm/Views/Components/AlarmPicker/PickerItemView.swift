//
//  PickerItemView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import UIKit

import FeatureResources

import SnapKit

class PickerItemView: UIView {
    
    // Sub view
    private let label: UILabel = .init()
    
    
    //
    let selectionItem: SelectionItem
    
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 48, height: 48)
    }
    
    
    init(item: SelectionItem) {
        
        self.selectionItem = item
        
        super.init(frame: .zero)
        
        setupUI()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        
        label.displayText = selectionItem.displayingText
            .displayText(font: .title1Medium, color: R.Color.white100)
    }
    
    
    private func setupLayout() {
        
        addSubview(label)
        label.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
        }
    }
}
