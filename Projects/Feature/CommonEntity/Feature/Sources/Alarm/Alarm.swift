//
//  Alarm.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/2/25.
//

import Foundation

public struct Alarm: Identifiable, Equatable, Codable, Hashable {
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
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(meridiem)
        hasher.combine(hour)
        hasher.combine(minute)
        hasher.combine(repeatDays)
        hasher.combine(snoozeOption)
        hasher.combine(soundOption)
        hasher.combine(isActive)
    }
}

extension Alarm {
    public func nextDateComponents(from now: Date = Date()) -> DateComponents {
        let calendar = Calendar.current

        // 12시간제를 24시간제로 변환
        let hour24: Int = {
            switch meridiem {
            case .am:
                return hour.value     // 0은 자정(12AM)으로 간주
            case .pm:
                return (hour.value == 0 ? 12 : hour.value + 12)  // 0은 정오(12PM)으로 간주
            }
        }()
        
        // 오늘 날짜를 기준으로 알람 시간 생성
        guard let alarmToday = calendar.date(
            bySettingHour: hour24,
            minute: minute.value,
            second: 0,
            of: now
        ) else {
            fatalError("알람 날짜 생성 실패")
        }
        
        // 현재 시간이 이미 지난 경우 내일로, 아니면 오늘로
        let finalDate: Date = (alarmToday <= now)
            ? calendar.date(byAdding: .day, value: 1, to: alarmToday)!
            : alarmToday
        
        return calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: finalDate)
    }
}
