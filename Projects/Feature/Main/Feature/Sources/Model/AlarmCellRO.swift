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
    var isEveryWeekRepeating: Bool
    var isExceptForHoliday: Bool
    var alarmDayText: String
    var meridiemText: String
    var hourAndMinuteText: String
    
    var isToggleOn: Bool
    var isChecked: Bool
    var alarmRowMode: AlarmListMode
    
//    var hourAndMinuteDisplayText: String {
//        var hourText = "00"
//        if hour.value < 10 {
//            hourText = "0\(hour)"
//        } else {
//            hourText = "\(hour)"
//        }
//        var minuteText = "00"
//        if minute.value < 10 {
//            minuteText = "0\(minute)"
//        } else {
//            minuteText = "\(minute)"
//        }
//        return "\(hourText):\(minuteText)"
//    }
}
