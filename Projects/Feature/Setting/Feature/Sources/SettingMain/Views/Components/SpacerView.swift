//
//  asd.swift
//  Setting
//
//  Created by choijunios on 2/13/25.
//

import UIKit

final class SpacerView: UIView {
    private let width: CGFloat?
    private let height: CGFloat?
    
    override var intrinsicContentSize: CGSize {
        .init(
            width: width ?? UIView.noIntrinsicMetric,
            height: height ?? UIView.noIntrinsicMetric
        )
    }
    
    init(width: CGFloat? = nil, height: CGFloat? = nil) {
        self.width = width
        self.height = height
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { nil }
}


// MARK: Public inteface
extension SpacerView {
    @discardableResult
    func update(color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
}
