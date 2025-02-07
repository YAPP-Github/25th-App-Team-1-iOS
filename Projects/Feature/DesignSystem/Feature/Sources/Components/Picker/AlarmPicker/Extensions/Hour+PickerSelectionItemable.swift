//
//  Hour+PickerSelectionItemable.swift
//  FeatureDesignSystem
//
//  Created by 손병근 on 2/2/25.
//

import FeatureCommonDependencies

extension Hour: PickerSelectionItemable {
    var content: String {
        "\(value)"
    }
    
    var displayingText: String {
        "\(value)"
    }
}

