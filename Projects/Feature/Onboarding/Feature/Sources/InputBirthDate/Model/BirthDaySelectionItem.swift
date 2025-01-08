//
//  BirthDaySelectionItem.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import UIKit

struct BirthDaySelectionItem: Hashable {
    
    let content: String
    let displayingText: String
    let contentSize: CGSize
    
    init(content: String, displayingText: String, contentSize: CGSize) {
        self.displayingText = displayingText
        self.content = content
        self.contentSize = contentSize
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(content)
    }
}
