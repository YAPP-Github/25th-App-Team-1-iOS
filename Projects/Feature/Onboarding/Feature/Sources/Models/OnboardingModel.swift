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
    public var alarm: Alarm = Alarm(
        meridiem: .am,
        hour: .init(6)!,
        minute: .init(0)!,
        repeatDays: AlarmDays(days: [.monday, .tuesday, .wednesday, .thursday, .friday]),
        snoozeOption: .init(isSnoozeOn: true, frequency: .fiveMinutes, count: .fiveTimes),
        soundOption: .init(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: R.AlarmSound.allCases.sorted(by: { $0.title < $1.title }).first?.title ?? "")
    )
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


