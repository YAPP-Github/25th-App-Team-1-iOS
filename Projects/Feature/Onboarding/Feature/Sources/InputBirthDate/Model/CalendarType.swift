//
//  CalendarType.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import Foundation

public enum CalendarType {
    
    case gregorian
    case lunar
    
    public static var displayOrderList: [Self] {
        [.gregorian, .lunar]
    }
    
    public var displayKoreanText: String {
        switch self {
        case .gregorian:
            "양력"
        case .lunar:
            "음력"
        }
    }
    
    public var content: String {
        switch self {
        case .gregorian:
            "gregorian"
        case .lunar:
            "lunar"
        }
    }
    
    public var calendarIdentifier: Calendar.Identifier {
        switch self {
        case .gregorian:
            .gregorian
        case .lunar:
            .chinese
        }
    }
}
