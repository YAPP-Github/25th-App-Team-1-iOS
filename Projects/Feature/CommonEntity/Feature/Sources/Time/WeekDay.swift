//
//  WeekDay.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public enum WeekDay: Int, CaseIterable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    public init?(calendarWeekday: Int) {
        self.init(rawValue: calendarWeekday)
    }
    
    public static let weekdays = Set([monday, tuesday, wednesday, thursday, friday])
    public static let weekends = Set([sunday, saturday])
    
    // 일요일...월요일
    public var toKoreanFormat: String {
        return switch self {
        case .sunday:
            "일요일"
        case .monday:
            "월요일"
        case .tuesday:
            "화요일"
        case .wednesday:
            "수요일"
        case .thursday:
            "목요일"
        case .friday:
            "금요일"
        case .saturday:
            "토요일"
        }
    }
    
    public var toShortKoreanFormat: String {
        return switch self {
        case .sunday:
            "일"
        case .monday:
            "월"
        case .tuesday:
            "화"
        case .wednesday:
            "수"
        case .thursday:
            "목"
        case .friday:
            "금"
        case .saturday:
            "토"
        }
    }
}
