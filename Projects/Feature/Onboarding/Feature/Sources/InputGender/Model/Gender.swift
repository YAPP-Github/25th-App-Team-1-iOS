//
//  Gender.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

enum Gender {
    
    case male
    case female
    
    var displayingName: String {
        switch self {
        case .male:
            "남성"
        case .female:
            "여성"
        }
    }
}
