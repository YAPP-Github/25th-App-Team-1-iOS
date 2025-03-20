//
//  AlarmMissionType.swift
//  AlarmMission
//
//  Created by choijunios on 3/4/25.
//

import RIBs

public enum AlarmMissionType: String {
    case shake = "shake_mission"
    case tap = "tap_mission"
    
    public init(key: String) {
        let instance = AlarmMissionType(rawValue: key)
        self = instance ?? .defaultValue
    }
    
    public static var defaultValue: Self {
        debugPrint("알람미션 기본값 사용됨")
        return .shake
    }
    
    var logPropertyValue: String {
        switch self {
        case .shake:
            "shake"
        case .tap:
            "tap"
        }
    }
}
