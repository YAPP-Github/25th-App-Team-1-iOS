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
    public func nextDateComponents(from now: Date = Date()) -> [DateComponents] {
        let calendar = Calendar.current
        guard repeatDays.days.isEmpty else {
            return nextDateComponents(for: repeatDays.days, hour: hour, minute: minute)
        }
        guard let alarmToday = calendar.date(
            bySettingHour: hour.to24Hour(with: meridiem),
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
        
        return [calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: finalDate)]
    }
    
    private func nextDateComponents(for selectedWeekDays: Set<WeekDay>, hour: Hour, minute: Minute) -> [DateComponents] {
        let calendar = Calendar.current
        let now = Date()
        var componentsList: [DateComponents] = []
        
        for weekDay in selectedWeekDays {
            // 원하는 시간으로 기본 컴포넌트를 구성
            var components = DateComponents()
            components.hour = hour.value
            components.minute = minute.value
            components.second = 0
            components.weekday = weekDay.rawValue
            
            // now 이후에 해당 요일에 해당하는 다음 날짜를 계산
            if let nextDate = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime) {
                // 반복 알람을 위한 DateComponents를 생성할 때는 연,월,일 정보 없이 요일과 시간만 사용해도 무방해
                let finalComponents = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: nextDate)
                componentsList.append(finalComponents)
            }
        }
        return componentsList
    }
    
    public func earliestDateComponent() -> DateComponents? {
        let calendar = Calendar.current
        let now = Date()
        var earliestTuple: (date: Date, components: DateComponents)?
        
        for components in nextDateComponents() {
            // 각 components에 대해 현재 이후의 다음 발생 시점을 구함
            if let nextDate = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime) {
                if let currentEarliest = earliestTuple {
                    if nextDate < currentEarliest.date {
                        earliestTuple = (nextDate, components)
                    }
                } else {
                    earliestTuple = (nextDate, components)
                }
            }
        }
        
        return earliestTuple?.components
    }
}
