//
//  Gender.swift
//  FeatureCommonEntity
//
//  Created by choijunios on 2/13/25.
//

public enum Gender: String, Codable {
    
    case male = "MALE"
    case female = "FEMALE"
    
    public var displayingName: String {
        switch self {
        case .male:
            "남성"
        case .female:
            "여성"
        }
    }
}
