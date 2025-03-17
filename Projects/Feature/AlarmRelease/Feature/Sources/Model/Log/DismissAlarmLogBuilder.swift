//
//  DismissAlarmLogBuilder.swift
//  AlarmRelease
//
//  Created by choijunios on 3/17/25.
//

import FeatureLogger

final class DismissAlarmLogBuilder: LogObjectBuilder {
    init(alarmId: String, isFirstAlarm: Bool) {
        super.init(eventType: "alarm_dismiss")
        setProperty(key: "alarm_id", value: alarmId)
        setProperty(key: "dismiss_is_first_alarm", value: isFirstAlarm)
    }
}
