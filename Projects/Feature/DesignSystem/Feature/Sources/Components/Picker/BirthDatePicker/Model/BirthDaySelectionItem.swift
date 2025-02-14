//
//  BirthDaySelectionItem.swift
//  FeatureDesignSystem
//
//  Created by choijunios on 1/8/25.
//

import UIKit

public struct BirthDaySelectionItem: Hashable {
    
    public let content: String
    public let displayingText: String
    public let contentSize: CGSize
    
    public init(content: String, displayingText: String, contentSize: CGSize) {
        self.displayingText = displayingText
        self.content = content
        self.contentSize = contentSize
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(content)
    }
}
