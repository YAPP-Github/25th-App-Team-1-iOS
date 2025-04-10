//
//  ExecuteSnoozeLogBuilder.swift
//  AlarmRelease
//
//  Created by choijunios on 3/17/25.
//

import FeatureLogger

final class ExecuteSnoozeLogBuilder: LogObjectBuilder {
    
    init(alarmId: String) {
        super.init(eventType: "alarm_snooze")
        setProperty(key: "alarm_id", value: alarmId)
    }
}
