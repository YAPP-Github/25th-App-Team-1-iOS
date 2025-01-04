//
//  CTAButton.swift
//  FeatureOnboarding
//
//  Created by 손병근 on 1/4/25.
//

import UIKit

class CTAButton: UIButton {
    var normalBackgroundColor: UIColor?
    var disabledBackgroundColor: UIColor?
    
    override var isEnabled: Bool {
        get {
            return super.isEnabled
        }
        set {
            super.isEnabled = newValue
            if newValue {
                backgroundColor = normalBackgroundColor
            } else {
                backgroundColor = disabledBackgroundColor
            }
        }
    }
}
