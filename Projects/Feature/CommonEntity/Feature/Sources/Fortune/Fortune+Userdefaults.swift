//
//  Fortune+Userdefaults.swift
//  FeatureCommonEntity
//
//  Created by ever on 2/14/25.
//

import Foundation

public extension UserDefaults {
    /// 오늘 날짜를 기반으로 한 key 생성 ("fortuneId_yyyy-MM-dd")
    private func fortuneIdKey(for date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "fortuneId_\(formatter.string(from: date))"
    }
    
    /// Fortune의 id를 저장
    func setDailyFortuneId(_ id: Int, for date: Date = Date()) {
        let key = fortuneIdKey(for: date)
        self.set(id, forKey: key)
    }
    
    /// 오늘 날짜 기준으로 저장된 DailyFortuneResponse의 id를 읽어옴
    func dailyFortuneId(for date: Date = Date()) -> Int? {
        let key = fortuneIdKey(for: date)
        return self.object(forKey: key) as? Int
    }
}
