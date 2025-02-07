//
//  Gender.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

public enum Gender {
    
    case male
    case female
    
    public var displayingName: String {
        switch self {
        case .male:
            "남성"
        case .female:
            "여성"
        }
    }
}
