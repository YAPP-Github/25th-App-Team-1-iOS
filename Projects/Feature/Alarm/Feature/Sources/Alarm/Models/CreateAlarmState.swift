//
//  CreateAlarmState.swift
//  FeatureAlarm
//
//  Created by ever on 1/1/25.
//

import Foundation

// 오전/오후를 나타내는 열거형
enum Meridiem: String, Codable {
    case am = "AM"
    case pm = "PM"
}

// 요일을 나타내는 열거형
enum Weekday: String, Codable, CaseIterable {
    case sunday = "일요일"
    case monday = "월요일"
    case tuesday = "화요일"
    case wednesday = "수요일"
    case thursday = "목요일"
    case friday = "금요일"
    case saturday = "토요일"
    
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
}

// 반복 간격을 나타내는 열거형
enum RepetitionInterval: Int, Codable {
    case none = 0
    case threeMinutes = 3
    case fiveMinutes = 5
}

// 알람을 나타내는 구조체
struct Alarm: Codable, Equatable {
    static let `default` = Alarm(meridiem: .pm, hour: 4, minute: 37)
    var id: UUID = UUID()
    var meridiem: Meridiem
    var hour: Int // 1 ~ 12
    var minute: Int // 0 ~ 59
    var repeatDays: Set<Weekday> // 반복할 요일
    var repetitionInterval: RepetitionInterval
    
    // 초기화 메서드
    init(meridiem: Meridiem,
         hour: Int,
         minute: Int,
         repeatDays: Set<Weekday> = [],
         repetitionInterval: RepetitionInterval = .none) {
        self.meridiem = meridiem
        self.hour = hour
        self.minute = minute
        self.repeatDays = repeatDays
        self.repetitionInterval = repetitionInterval
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
        components.hour = meridiem == .am ? hour % 12 : (hour % 12) + 12
        components.minute = minute
        return components
    }
}
