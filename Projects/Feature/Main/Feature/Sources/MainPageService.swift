//
//  MainPageService.swift
//  FeatureMain
//
//  Created by ever on 2/7/25.
//

import FeatureCommonDependencies
import FeatureAlarmCommon

protocol MainPageServiceable {
    func getAllAlarm() -> [Alarm]
    func addAlarm(_ alarm: Alarm)
    func updateAlarm(_ alarm: Alarm)
    func deleteAlarm(_ alarm: Alarm)
}

struct MainPageService: MainPageServiceable {
    func getAllAlarm() -> [Alarm] {
        return AlarmStore.shared.getAll()
    }
    
    func addAlarm(_ alarm: Alarm) {
        AlarmScheduler.shared.addAlarm(alarm)
    }
    func updateAlarm(_ alarm: Alarm) {
        AlarmScheduler.shared.updateAlarm(alarm)
    }
    func deleteAlarm(_ alarm: Alarm) {
        AlarmScheduler.shared.deleteAlarm(alarm)
    }
}
