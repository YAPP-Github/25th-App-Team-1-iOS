//
//  Minute+PickerSelectionItemable.swift
//  FeatureDesignSystem
//
//  Created by 손병근 on 2/2/25.
//

import FeatureCommonEntity

extension Minute: PickerSelectionItemable {
    var content: String {
        "\(value)"
    }
    
    var displayingText: String {
        String(format: "%02d", value)
    }
}
