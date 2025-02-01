//
//  AlarmIterationType.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

enum AlarmIterationType {
    case everyDays(days: [Days])
    case specificDay(month: Int, day: Int)
    
    var dayDisplayText: String {
        switch self {
        case .everyDays(let days):
            return days.sorted(by: {$0.rawValue<$1.rawValue})
                .map({$0.korOneWord}).joined(separator: ",")
        case .specificDay(let month, let day):
            return "\(month)월 \(day)일"
        }
    }
    
    var showIsEveryWeekImage: Bool {
        switch self {
        case .everyDays:
            true
        case .specificDay:
            false
        }
    }
    
    var showHolidayBadge: Bool {
        switch self {
        case .everyDays(let days):
            return days.isRestOnHoliday
        case .specificDay:
            return false
        }
    }
}
