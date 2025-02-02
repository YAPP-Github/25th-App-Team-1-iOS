//
//  AlarmDays.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public struct AlarmDays {
    public private(set) var days: Set<WeekDay>
    public init(days: Set<WeekDay> = []) {
        self.days = days
    }
    
    /// 특정 요일 추가
    public mutating func add(_ day: WeekDay) {
        days.insert(day)
    }
    
    /// 특정 요일 제거
    public mutating func remove(_ day: WeekDay) {
        days.remove(day)
    }
    
}
