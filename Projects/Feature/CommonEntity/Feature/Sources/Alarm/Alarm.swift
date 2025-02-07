//
//  Alarm.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/2/25.
//

import Foundation

public struct Alarm: Identifiable, Equatable, Codable {
    public var id: String
    public var meridiem: Meridiem
    public var hour: Hour
    public var minute: Minute
    public var repeatDays: AlarmDays // 반복할 요일
    public var snoozeOption: SnoozeOption
    public var soundOption: SoundOption
    public var isActive: Bool
    
    // 초기화 메서드
    public init(
        meridiem: Meridiem,
        hour: Hour,
        minute: Minute,
        repeatDays: AlarmDays,
        snoozeOption: SnoozeOption,
        soundOption: SoundOption,
        isActive: Bool = true
    ) {
        self.id = UUID().uuidString
        self.meridiem = meridiem
        self.hour = hour
        self.minute = minute
        self.repeatDays = repeatDays
        self.snoozeOption = snoozeOption
        self.soundOption = soundOption
        self.isActive = isActive
    }
    
    public static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.id == rhs.id
    }
}
