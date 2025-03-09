//
//  AlarmScheduler.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/7/25.
//

import FeatureCommonEntity

public protocol AlarmScheduler {   
    func schedule(alarm: Alarm)
    func unschedule(alarm: Alarm)
}
