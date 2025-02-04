//
//  SnoozeOptionSelectable.swift
//  FeatureAlarm
//
//  Created by ever on 2/3/25.
//

import FeatureCommonDependencies

protocol SnoozeOptionSelectable {
    var title: String { get }
    var value: String { get }
    func isEqualTo(_ other: SnoozeOptionSelectable) -> Bool
}

extension SnoozeFrequency: SnoozeOptionSelectable {
    var title: String {
        toKoreanFormat
    }
    
    var value: String {
        toKoreanFormat
    }
    
    func isEqualTo(_ other: any SnoozeOptionSelectable) -> Bool {
        guard let other = other as? SnoozeFrequency else {
            return false
        }
        return self.rawValue == other.rawValue
    }
}

extension SnoozeCount: SnoozeOptionSelectable {
    var title: String {
        toKoreanTitleFormat
    }
    
    var value: String {
        toKoreanValueFormat
    }
    
    func isEqualTo(_ other: any SnoozeOptionSelectable) -> Bool {
        guard let other = other as? SnoozeCount else {
            return false
        }
        return self.rawValue == other.rawValue
    }
}
