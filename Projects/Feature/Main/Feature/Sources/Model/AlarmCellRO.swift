//
//  AlarmCellRO.swift
//  Main
//
//  Created by choijunios on 2/7/25.
//

import FeatureCommonEntity

struct AlarmCellRO: Identifiable, Hashable {
    var id: String { alarm.id }
    
    enum Mode {
        case idle
        case deletion
    }
    var mode: Mode
    var isSelectedForDeleteion: Bool
    var alarm: Alarm
    
    public static func == (lhs: AlarmCellRO, rhs: AlarmCellRO) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(alarm)
        hasher.combine(mode)
        hasher.combine(isSelectedForDeleteion)
    }
}
