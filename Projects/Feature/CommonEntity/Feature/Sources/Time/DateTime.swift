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
    public let meridiem: Meridiem
    public let hour: Hour
    public let minute: Minute
    public let second: Second
    
    public var dateComponents: DateComponents {
        var hourValue = hour.value
        if meridiem == .pm {
            hourValue += 12
        }
        
        return DateComponents(
            year: year.value,
            month: month.rawValue,
            day: day.value,
            hour: hourValue,
            minute: minute.value,
            second: second.value
        )
    }
    
    public func toDate() -> Date? {
        return Calendar.current.date(from: dateComponents)
    }
}
