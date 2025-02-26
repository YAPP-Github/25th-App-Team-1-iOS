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
    public var alarm: Alarm = {
        var hour = Hour(6)!
        var minute = Minute(0)!
        var meridiem: Meridiem = .am
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: .now)
        
        if let currentHour = dateComponents.hour {
            if currentHour >= 12 {
                meridiem = .pm
            }
            if currentHour >= 13, let formatted = Hour(currentHour-12) {
                hour = formatted
            } else if let formatted = Hour(currentHour) {
                hour = formatted
            }
        }
        if let currentMinute = dateComponents.minute, let formatted = Minute(currentMinute) {
            minute = formatted
        }
        
        let alarm = Alarm(
            meridiem: meridiem,
            hour: hour,
            minute: minute,
            repeatDays: AlarmDays(days: [.monday, .tuesday, .wednesday, .thursday, .friday]),
            snoozeOption: .init(isSnoozeOn: true, frequency: .fiveMinutes, count: .fiveTimes),
            soundOption: .init(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: R.AlarmSound.Marimba.title)
        )
        return alarm
    }()
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


