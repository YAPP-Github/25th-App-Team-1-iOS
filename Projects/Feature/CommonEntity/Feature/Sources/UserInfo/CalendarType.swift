//
//  CalendarType.swift
//  FeatureCommonEntity
//
//  Created by choijunios on 2/13/25.
//

import Foundation

public enum CalendarType: String, Decodable {
    case gregorian = "SOLAR"
    case lunar = "LUNAR"
    
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
