//
//  MeridiemItem.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/6/25.
//

enum MeridiemItem: CaseIterable {
    
    case ante
    case post
    
    var content: String {
        
        switch self {
        case .ante:
            "AM"
        case .post:
            "PM"
        }
    }
    
    var displayingText: String {
        switch self {
        case .ante:
            "오전"
        case .post:
            "오후"
        }
    }
}
