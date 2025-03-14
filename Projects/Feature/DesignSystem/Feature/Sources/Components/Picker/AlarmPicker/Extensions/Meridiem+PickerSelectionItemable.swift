//
//  Meridiem+PickerSelectionItemable.swift
//  FeatureDesignSystem
//
//  Created by 손병근 on 2/2/25.
//

import FeatureCommonDependencies

extension Meridiem: PickerSelectionItemable {
    var content: String {
        rawValue
    }
    
    var displayingText: String {
        toKoreanFormat
    }
}
