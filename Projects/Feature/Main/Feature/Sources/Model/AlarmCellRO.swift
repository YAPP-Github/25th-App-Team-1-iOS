//
//  AlarmCellRO.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

import Foundation

struct AlarmCellRO: Identifiable {
    
    let id: String
    
    var iterationType: AlarmIterationType
    var meridiem: Meridiem
    var hour: Int
    var minute: Int?
    var isActive: Bool
    
    init(
        id: String = UUID().uuidString,
        iterationType: AlarmIterationType,
        meridiem: Meridiem,
        hour: Int,
        minute: Int?,
        isActive: Bool
    ) {
        self.id = id
        self.iterationType = iterationType
        self.meridiem = meridiem
        self.hour = hour
        self.minute = minute
        self.isActive = isActive
    }
    
    var hourAndMinuteDisplayText: String {
        var hourText = "00"
        if hour < 10 {
            hourText = "0\(hour)"
        } else {
            hourText = "\(hour)"
        }
        var minuteText = "00"
        if let minute = minute {
            if minute < 10 {
                minuteText = "0\(minute)"
            } else {
                minuteText = "\(minute)"
            }
        }
        return "\(hourText):\(minuteText)"
    }
}
