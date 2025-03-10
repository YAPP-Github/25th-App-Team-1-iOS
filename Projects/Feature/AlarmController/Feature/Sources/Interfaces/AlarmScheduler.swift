//
//  AlarmScheduler.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/7/25.
//

import FeatureCommonEntity

public enum AlarmScheduleContent: CaseIterable {
    case initialLocalNotification
    case registerLocalNotificationRepeatedly
    case audio
    case registerConsecutiveAlarm
    case vibration
    
    var contentKey: String {
        switch self {
        case .initialLocalNotification:
            "initialLocalNotification"
        case .registerLocalNotificationRepeatedly:
            "repeatLocalNotification"
        case .audio:
            "audio"
        case .registerConsecutiveAlarm:
            "registerConsecutiveAlarm"
        case .vibration:
            "vibration"
        }
    }
    
    static var backgroundTasks: [Self] {
        [
            .registerLocalNotificationRepeatedly,
            .audio,
            .registerConsecutiveAlarm,
            .vibration,
        ]
    }
}

public enum IdMatchingType {
    case exact
    case contains
}

public extension Array where Element == AlarmScheduleContent {
    static var all: [AlarmScheduleContent] { AlarmScheduleContent.allCases }
    
    static var backgroundTasks: [AlarmScheduleContent] { AlarmScheduleContent.backgroundTasks }
}

public protocol AlarmScheduler {   
    func schedule(contents: [AlarmScheduleContent], alarm: Alarm)
    func inactivateSchedule(matchingType: IdMatchingType, contents: [AlarmScheduleContent], alarm: Alarm)
}
