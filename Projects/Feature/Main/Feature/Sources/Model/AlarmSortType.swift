//
//  AlarmSortType.swift
//  Main
//
//  Created by choijunios on 3/9/25.
//

import FeatureCommonEntity

enum SortDirection {
    case ascending, descending
}

enum AlarmSortType {
    case hourAndMinute
    
    func compare(direction: SortDirection) -> (Alarm, Alarm) -> Bool {
        switch self {
        case .hourAndMinute:
            return { (lhs, rhs) -> Bool in
                let lhs_hour = lhs.hour.to24Hour(with: lhs.meridiem)
                let rhs_hour = rhs.hour.to24Hour(with: rhs.meridiem)
                
                let lhs_minute = lhs.minute.value
                let rhs_minute = rhs.minute.value
                
                if lhs_hour == rhs_hour {
                    // 시간이 같은 경우
                    if lhs_minute == rhs_minute {
                        // 시간과 분이 같은 경우
                        return lhs.id < rhs.id
                    } else {
                        return lhs_minute < rhs_minute
                    }
                } else {
                    // 시간이 다른 경우
                    return lhs_hour < rhs_hour
                }
            }
        }
    }
}
