//
//  SnoozeOption.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/2/25.
//

import Foundation

public struct SnoozeOption {
    public var isSnoozeOn: Bool
    public var frequency: SnoozeFrequency
    public var count: SnoozeCount
}

public enum SnoozeFrequency: Int, CaseIterable {
    case oneMinute = 1
    case threeMinutes = 3
    case fiveMinutes = 5
    case tenMinutes = 10
    case fifteenMinutes = 15
    
    public var toKoreanFormat: String {
        return switch self {
        case .oneMinute: "1분"
        case .threeMinutes: "3분"
        case .fiveMinutes: "5분"
        case .tenMinutes: "10분"
        case .fifteenMinutes: "15분"
        }
    }
}

public enum SnoozeCount: Int, CaseIterable {
    case once = 1
    case threeTimes = 3
    case fiveTimes = 5
    case tenTimes = 10
    case unlimited = -1
    
    public var toKoreanFormat: String {
        return switch self {
        case .once: "1회"
        case .threeTimes: "3회"
        case .fiveTimes: "5회"
        case .tenTimes: "10회"
        case .unlimited: "무한"
        }
    }
}
