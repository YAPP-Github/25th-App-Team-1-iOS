//
//  CreateAlarmState.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import Foundation
import FeatureDesignSystem

// 요일을 나타내는 열거형
enum DayOfWeek: Codable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var intValue: Int {
        switch self {
        case .sunday: return 0
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        }
    }
    
    static let weekdays = Set([monday, tuesday, wednesday, thursday, friday])
    static let weekends = Set([sunday, saturday])
}

enum SnoozeFrequency: String, CaseIterable, Codable {
    case oneMinute = "1분"
    case threeMinutes = "3분"
    case fiveMinutes = "5분"
    case tenMinutes = "10분"
    case fifteenMinutes = "15분"
    
    var minutes: Int {
        switch self {
        case .oneMinute:
            return 1
        case .threeMinutes:
            return 3
        case .fiveMinutes:
            return 5
        case .tenMinutes:
            return 10
        case .fifteenMinutes:
            return 15
        }
    }
}

enum SnoozeCount: String, CaseIterable, Codable {
    case once = "1회"
    case threeTimes = "3회"
    case fiveTimes = "5회"
    case tenTimes = "10회"
    case unlimited = "무한"
}

// 알람을 나타내는 구조체
struct Alarm: Codable, Equatable {
    static let `default` = Alarm(meridiem: .pm, hour: 4, minute: 37)
    var id: UUID = UUID()
    var meridiem: MeridiemItem
    var hour: Int // 1 ~ 12
    var minute: Int // 0 ~ 59
    var repeatDays: Set<DayOfWeek> // 반복할 요일
    var snoozeFrequency: SnoozeFrequency?
    var snoozeCount: SnoozeCount?
    
    // 초기화 메서드
    init(meridiem: MeridiemItem,
         hour: Int,
         minute: Int,
         repeatDays: Set<DayOfWeek> = [],
         snoozeFrequency: SnoozeFrequency? = nil,
         snoozeCount: SnoozeCount? = nil
    ) {
        self.meridiem = meridiem
        self.hour = hour
        self.minute = minute
        self.repeatDays = repeatDays
        self.snoozeFrequency = snoozeFrequency
    }
    
    // 에러 정의
    enum AlarmError: Error, LocalizedError {
        case invalidHour
        case invalidMinute
        
        var errorDescription: String? {
            switch self {
            case .invalidHour:
                return "시간은 1부터 12 사이여야 합니다."
            case .invalidMinute:
                return "분은 0부터 59 사이여야 합니다."
            }
        }
    }
    
    // 알람 시간의 DateComponents 변환 메서드 (필요 시 사용)
    func toDateComponents() -> DateComponents {
        var components = DateComponents()
        components.hour = meridiem == .ante ? hour % 12 : (hour % 12) + 12
        components.minute = minute
        return components
    }
}
