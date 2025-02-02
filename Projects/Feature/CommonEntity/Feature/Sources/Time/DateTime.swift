//
//  DateTime.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public struct DateTime {
    public let year: Year
    public let month: Month
    public let day: Day
    public let hour: Hour
    public let minute: Minute
    public let second: Second
    
    public var dateComponents: DateComponents {
        return DateComponents(
            year: year.value,
            month: month.rawValue,
            day: day.value,
            hour: hour.value,
            minute: minute.value,
            second: second.value
        )
    }
    
    public func toDate() -> Date? {
        return Calendar.current.date(from: dateComponents)
    }
}
