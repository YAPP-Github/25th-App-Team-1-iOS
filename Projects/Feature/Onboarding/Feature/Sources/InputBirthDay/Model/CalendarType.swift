//
//  CalendarType.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import Foundation

enum CalendarType {
    
    case gregorian
    case lunar
    
    static var displayOrderList: [Self] {
        [.gregorian, .lunar]
    }
    
    var displayKoreanText: String {
        switch self {
        case .gregorian:
            "양력"
        case .lunar:
            "음력"
        }
    }
    
    var content: String {
        switch self {
        case .gregorian:
            "gregorian"
        case .lunar:
            "lunar"
        }
    }
}
