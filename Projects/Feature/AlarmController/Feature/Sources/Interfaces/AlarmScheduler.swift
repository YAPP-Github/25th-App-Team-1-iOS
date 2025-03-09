//
//  AlarmScheduler.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/7/25.
//

import FeatureCommonEntity

public enum AlarmScheduleContent: CaseIterable {
    case localNotification
    case backgroundTask
}

public extension Array where Element == AlarmScheduleContent {
    static var all: [AlarmScheduleContent] { AlarmScheduleContent.allCases }
}

public protocol AlarmScheduler {   
    func schedule(content: [AlarmScheduleContent], alarm: Alarm)
    func unschedule(content: [AlarmScheduleContent], alarm: Alarm)
}
