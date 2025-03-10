//
//  KeyGenerator.swift
//  FeatureAlarmController
//
//  Created by choijunios on 3/8/25.
//

enum KeyGenerator {
    static func notification(alarmId: String) -> String {
        "alarm_notification_\(alarmId)"
    }
    static func backgroundTask(content: String, alarmId: String) -> String {
        "alarm_background_task_\(content)_\(alarmId)"
    }
    static func audioTask(alarmId: String) -> String {
        "alarm_audio_\(alarmId)"
    }
}
