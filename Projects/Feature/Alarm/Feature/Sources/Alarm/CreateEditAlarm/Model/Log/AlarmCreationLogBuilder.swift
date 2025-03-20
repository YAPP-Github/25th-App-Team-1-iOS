//
//  AlarmCreationLogBuilder.swift
//  FeatureAlarm
//
//  Created by choijunios on 3/17/25.
//

import FeatureLogger
import FeatureCommonEntity

final class AlarmCreationLogBuilder: LogObjectBuilder {
    
    init(alarmId: String, repeatDays: AlarmDays, snoozeOption: SnoozeOption) {
        super.init(eventType: "alarm_create")
        setProperty(key: "alarm_id", value: alarmId)
        setProperty(key: "repeat_days", value: repeatDays.days.map(createDayText(day:)))
        setProperty(key: "snooze_option", value: [
            snoozeOption.frequency.rawValue,
            snoozeOption.count.rawValue
        ])
    }
    
    private func createDayText(day: WeekDay) -> String {
        switch day {
        case .sunday:
            "Sun"
        case .monday:
            "Mon"
        case .tuesday:
            "Tue"
        case .wednesday:
            "Wed"
        case .thursday:
            "Thu"
        case .friday:
            "Fri"
        case .saturday:
            "Sat"
        }
    }
}
