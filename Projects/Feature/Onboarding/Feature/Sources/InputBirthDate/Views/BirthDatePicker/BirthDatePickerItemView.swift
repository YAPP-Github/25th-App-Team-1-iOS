//
//  BirthDatePickerItemView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import UIKit

import FeatureUIDependencies

import FeatureThirdPartyDependencies

final class BirthDatePickerItemView: UIView {
    
    // Sub view
    private let label: UILabel = .init()
    
    
    // View model
    private var currentLabelText: String?
    private(set) var content: String
    
    
    //
    private var viewSize: CGSize
    private var titleLabelConfig: TitleLabelConfig?
    
    
    override var intrinsicContentSize: CGSize {
        return viewSize
    }
    
    
    init(content: String, viewSize: CGSize) {
        
        self.content = content
        self.viewSize = viewSize
        
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        
        
        self.backgroundColor = .clear
    }
    

    private func setupLayout() {
        
        addSubview(label)
        label.snp.makeConstraints { make in
            
            make.center.equalToSuperview()
        }
    }
}


// MARK: Public interface
extension BirthDatePickerItemView {
    
    @discardableResult
    public func update(titleLabelConfig: TitleLabelConfig) -> Self {
        
        self.titleLabelConfig = titleLabelConfig
        
        label.displayText = currentLabelText?
            .displayText(font: titleLabelConfig.font, color: titleLabelConfig.textColor)
        
        return self
    }
    
    
    @discardableResult
    public func update(titleLabelText: String) -> Self {
        
        self.currentLabelText = titleLabelText
        
        guard let titleLabelConfig else { return self }
        
        label.displayText = titleLabelText
            .displayText(font: titleLabelConfig.font, color: titleLabelConfig.textColor)
        
        return self
    }
    
    
    @discardableResult
    public func update(content newContent: String) -> Self {
        
        self.content = newContent
        
        return self
    }
    
    
    @discardableResult
    public func update(viewSize newViewSize: CGSize) -> Self {
        
        if self.viewSize != newViewSize {
            
            self.viewSize = newViewSize
            self.invalidateIntrinsicContentSize()
        }
        
        return self
    }
}


// MARK: State
extension BirthDatePickerItemView {
    
    struct TitleLabelConfig {
        let font: R.Font
        let textColor: UIColor
    }
}
