//
//  UserDefaults+dailyFortunCheck.swift
//  Main
//
//  Created by choijunios on 2/18/25.
//

import Foundation

public extension UserDefaults {
    /// 오늘 날짜를 기반으로 한 key 생성 ("fortuneId_yyyy-MM-dd")
    private func dailyFortuneCheckedKey(for date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "fortune_is_checked_\(formatter.string(from: date))"
    }
    
    /// Fortune이 확인됬는지 여부
    func setDailyFortuneChecked(isChecked: Bool, for date: Date = Date()) {
        let key = dailyFortuneCheckedKey(for: date)
        UserDefaults.standard.set(isChecked, forKey: key)
    }
    
    /// 오늘 날짜 기준으로 저장된 DailyFortuneResponse의 id를 읽어옴
    func dailyFortuneIsChecked(for date: Date = Date()) -> Bool {
        let key = dailyFortuneCheckedKey(for: date)
        return UserDefaults.standard.bool(forKey: key)
    }
}
