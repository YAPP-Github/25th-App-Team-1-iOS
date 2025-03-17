//
//  UserDefaults+Ext.swift
//  AlarmRelease
//
//  Created by choijunios on 3/17/25.
//

import Foundation

extension UserDefaults {
    private func dailyFirstAlarmReleasedKey(for date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "first_alarm_is_released_\(formatter.string(from: date))"
    }
    
    func removeYesterDay(base: Date = .init()) {
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: base)!
        let key = dailyFirstAlarmReleasedKey(for: yesterDay)
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func setDailyFirstAlarmReleased(isChecked: Bool, for date: Date = Date()) {
        let key = dailyFirstAlarmReleasedKey(for: date)
        UserDefaults.standard.set(isChecked, forKey: key)
    }
    
    func dailyFirstAlarmIsReleased(for date: Date = Date()) -> Bool {
        let key = dailyFirstAlarmReleasedKey(for: date)
        return UserDefaults.standard.bool(forKey: key)
    }
}
