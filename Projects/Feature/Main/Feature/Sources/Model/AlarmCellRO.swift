//
//  AlarmCellRO.swift
//  Main
//
//  Created by choijunios on 2/7/25.
//

import FeatureCommonEntity

struct AlarmCellRO {
    var id: String
    var isEveryWeekRepeating: Bool
    var isExceptForHoliday: Bool
    var alarmDayText: String
    var meridiemText: String
    var hourAndMinuteText: String
    
    var isToggleOn: Bool
    var isChecked: Bool
    var alarmRowMode: AlarmListMode
}
