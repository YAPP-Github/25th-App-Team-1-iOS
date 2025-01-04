//
//  UILabel+Extension.swift
//  FeatureResources
//
//  Created by 손병근 on 1/4/25.
//

import UIKit

public extension UILabel {
    var displayText: NSAttributedString? {
        get {
            return attributedText
        }
        set {
            attributedText = newValue
        }
    }
}
