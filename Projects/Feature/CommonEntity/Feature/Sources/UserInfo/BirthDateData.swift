//
//  BirthDateData.swift
//  FeatureCommonEntity
//
//  Created by choijunios on 2/13/25.
//

public struct BirthDateData {
    public let calendarType: CalendarType
    public let year: Year
    public let month: Month
    public let day: Day
    
    public init(calendarType: CalendarType, year: Year, month: Month, day: Day) {
        self.calendarType = calendarType
        self.year = year
        self.month = month
        self.day = day
    }
}

public extension BirthDateData {
    func toDateString() -> String {
        String(format: "%d-%02d-%02d", year.value, month.rawValue, day.value)
    }
}
