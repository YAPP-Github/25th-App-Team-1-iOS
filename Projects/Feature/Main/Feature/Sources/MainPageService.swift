//
//  MainPageService.swift
//  FeatureMain
//
//  Created by ever on 2/7/25.
//

import UserNotifications
import FeatureUIDependencies
import FeatureCommonDependencies

protocol MainPageServiceable {
    func getAllAlarm() -> [Alarm]
    func addAlarm(_ alarm: Alarm)
    func updateAlarm(_ alarm: Alarm)
    func deleteAlarm(_ alarm: Alarm)
}

struct MainPageService: MainPageServiceable {
    func getAllAlarm() -> [Alarm] {
        AlarmStore.shared.getAll()
    }
    func addAlarm(_ alarm: Alarm) {
        AlarmStore.shared.add(alarm)
        guard let soundUrl = R.AlarmSound.allCases.first(where: { $0.title == alarm.soundOption.selectedSound })?.alarm else { return }
    }
    func updateAlarm(_ alarm: Alarm) {
        AlarmStore.shared.update(alarm)
    }
    func deleteAlarm(_ alarm: Alarm) {
        AlarmStore.shared.delete(alarm)
    }
