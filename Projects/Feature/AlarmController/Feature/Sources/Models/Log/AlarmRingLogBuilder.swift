//
//  AlarmRingLogBuilder.swift
//  AlarmController
//
//  Created by choijunios on 3/17/25.
//

import Foundation

import FeatureLogger

final class AlarmRingLogBuilder: LogObjectBuilder {
    init(alarmId: String, alarmDate: Date) {
        super.init(eventType: "alarm_ring")
        setProperty(key: "alarm_id", value: alarmId)
        setProperty(key: "alarm_time", value: formatTime(from: alarmDate))
    }
    
    private func formatTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24시간 형식 (07:30)
        formatter.locale = Locale(identifier: "ko_KR") // 한국 시간 기준
        return formatter.string(from: date)
    }
}
