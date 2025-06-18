//
//  OnboardingModel.swift
//  FeatureOnboarding
//
//  Created by ever on 1/14/25.
//

import Foundation
import FeatureCommonDependencies
import FeatureResources

public struct OnboardingModel {
    public var alarm: Alarm = .default
    public var birthDate: BirthDateData = {
        let calendar = CalendarType.gregorian
        let year = Year(2000)
        let month = Month(rawValue: 1)!
        let day = Day(1, calendar: calendar, month: month, year: year)!
        return .init(calendarType: calendar, year: year, month: month, day: day)
    }()
    public var bornTime: BornTimeData?
    public var name: String?
    public var gender: Gender?
}


