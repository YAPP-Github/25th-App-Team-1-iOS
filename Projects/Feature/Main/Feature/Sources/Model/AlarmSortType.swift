//
//  AlarmSortType.swift
//  Main
//
//  Created by choijunios on 3/9/25.
//

enum SortDirection {
    case ascending, descending
}

enum AlarmSortType {
    case hourAndMinute
    
    func compare(direction: SortDirection) -> (AlarmCellRO, AlarmCellRO) -> Bool {
        switch self {
        case .hourAndMinute:
            return { (lhs, rhs) -> Bool in
                let lh = lhs.hour.to24Hour(with: lhs.meridiem)
                let lm = lhs.minute.value
                let rh = rhs.hour.to24Hour(with: rhs.meridiem)
                let rm = rhs.minute.value
                if lh != rh { return lh < rh }
                else { return lm < rm }
            }
        }
    }
}
