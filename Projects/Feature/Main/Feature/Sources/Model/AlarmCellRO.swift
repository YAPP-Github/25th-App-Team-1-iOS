//
//  AlarmCellRO.swift
//  Main
//
//  Created by choijunios on 2/7/25.
//

import FeatureCommonEntity
import FeatureCommonEntity

struct AlarmCellRO: Hashable {
    var id: String
    var alarmDays: AlarmDays
    var meridiem: Meridiem
    var hour: Hour
    var minute: Minute
    var isToggleOn: Bool
    var isChecked: Bool
    var mode: AlarmListMode
    
    var hourAndMinuteDisplayText: String {
        var hourText = "00"
        if hour.value < 10 {
            hourText = "0\(hour)"
        } else {
            hourText = "\(hour)"
        }
        var minuteText = "00"
        if minute.value < 10 {
            minuteText = "0\(minute)"
        } else {
            minuteText = "\(minute)"
        }
        return "\(hourText):\(minuteText)"
    }
}
