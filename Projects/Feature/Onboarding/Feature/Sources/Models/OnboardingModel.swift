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
        repeatDays: AlarmDays(),
        snoozeOption: .init(isSnoozeOn: true, frequency: .fiveMinutes, count: .fiveTimes),
        soundOption: .init(isVibrationOn: true, isSoundOn: true, volume: 0.7, selectedSound: R.AlarmSound.allCases.sorted(by: { $0.title < $1.title }).first?.title ?? "")
    )
    public var birthDate: BirthDateData?
    public var bornTime: BornTimeData?
    public var name: String?
    public var gender: Gender?
}


