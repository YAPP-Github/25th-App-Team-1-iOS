//
//  SelectionItem.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import UIKit
import FeatureDesignSystem

struct PickerSelectionItem: PickerSelectionItemable, Hashable {
    let content: String
    let displayingText: String
    
    init(content: String, displayingText: String) {
        self.displayingText = displayingText
        self.content = content
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(content)
    }
}
