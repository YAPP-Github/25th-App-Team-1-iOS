//
//  AlarmDays.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public struct AlarmDays {
    public private(set) var days: Set<WeekDay>
    public var shoundTurnOffHolidayAlarm: Bool
    
    public init(
        days: Set<WeekDay> = [],
        shoundTurnOffHolidayAlarm: Bool = false
    ) {
        self.days = days
        self.shoundTurnOffHolidayAlarm = shoundTurnOffHolidayAlarm
    }
    
    /// 특정 요일 추가
    public mutating func add(_ day: WeekDay) {
        days.insert(day)
    }
    
    /// 특정 요일 제거
    public mutating func remove(_ day: WeekDay) {
        days.remove(day)
    }

    public func contains(_ day: WeekDay) -> Bool {
        days.contains(day)
    }
    
    /// 특정 요일 리스트 제거
    public mutating func subtract(_ days: Set<WeekDay>) {
        self.days.subtract(days)
    }
    
    public mutating func formUnion(_ days: Set<WeekDay>) {
        self.days.formUnion(days)
    }
    
    public func isSubset(of days: Set<WeekDay>) -> Bool {
        self.days.isSubset(of: days)
    }
}
