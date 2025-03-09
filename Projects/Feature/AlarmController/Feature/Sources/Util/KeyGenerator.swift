//
//  KeyGenerator.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

enum AlarmBackgoundTaskType: String, CaseIterable {
    case notification
    case soundAndRepeatDays
    case vibration
}

enum KeyGenerator {
    static func notification(alarmId: String) -> String {
        "alarm_notification_\(alarmId)"
    }
    static func backgroundTask(type: AlarmBackgoundTaskType, alarmId: String) -> String {
        "alarm_background_task_\(type.rawValue)_\(alarmId)"
    }
    static func audioTask(alarmId: String) -> String {
        "alarm_audio_\(alarmId)"
    }
}
