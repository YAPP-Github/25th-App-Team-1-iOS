//
//  AlarmCellRO.swift
//  Main
//
//  Created by choijunios on 2/7/25.
//

import FeatureCommonEntity

struct AlarmCellRO: Identifiable, Hashable {
    enum Mode {
        case idle
        case deletion
    }
    var alarm: Alarm
    var mode: Mode
    var isChecked: Bool
    
    var id: String { alarm.id }
    var isToggleOn: Bool { alarm.isActive }
    
    public static func == (lhs: AlarmCellRO, rhs: AlarmCellRO) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(alarm)
        hasher.combine(mode)
        hasher.combine(isChecked)
    }
}
