//
//  SelectionItem.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

struct SelectionItem {
    
    let content: String
    var displayingText: String
    
    init(content: String, displayingText: String) {
        self.displayingText = displayingText
        self.content = content
    }
}
