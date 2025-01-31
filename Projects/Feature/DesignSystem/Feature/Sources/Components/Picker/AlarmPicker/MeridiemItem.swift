//
//  MeridiemItem.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/6/25.
//

public enum MeridiemItem: CaseIterable, Codable {
    case ante
    case post
    
    public var content: String {
        switch self {
        case .ante:
            "AM"
        case .post:
            "PM"
        }
    }
    
    public var displayingText: String {
        switch self {
        case .ante:
            "오전"
        case .post:
            "오후"
        }
    }
}
