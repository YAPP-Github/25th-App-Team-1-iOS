//
//  AlarmCellRO.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

import Foundation

struct AlarmCellRO: Identifiable {
    
    let id: String
    
    let iterationType: AlarmIterationType
    let meridiem: Meridiem
    let hour: Int
    let minute: Int?
    var isActive: Bool
    
    init(id: String = UUID().uuidString,iterationType: AlarmIterationType, meridiem: Meridiem, hour: Int, minute: Int?, isActive: Bool) {
        self.id = id
        self.iterationType = iterationType
        self.meridiem = meridiem
        self.hour = hour
        self.minute = minute
        self.isActive = isActive
    }
}
