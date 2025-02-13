//
//  DotView.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

import FeatureUIDependencies

final class DotView: UIView {
    //
    private let diameter: CGFloat
    private let color: UIColor
    
    override var intrinsicContentSize: CGSize { .init(width: diameter, height: diameter) }
    
    init(diameter: CGFloat, color: UIColor) {
        self.diameter = diameter
        self.color = color
        super.init(frame: .zero)
        self.backgroundColor = color
    }
    required init?(coder: NSCoder) { nil }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = diameter/2
    }
}
