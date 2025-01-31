//
//  AlarmIterationType.swift
//  Main
//
//  Created by choijunios on 1/31/25.
//

enum AlarmIterationType {
    case everyDays(days: [Days])
    case specificDay(month: Int, day: Int)
}
