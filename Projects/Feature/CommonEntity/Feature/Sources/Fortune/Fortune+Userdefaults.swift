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
    func setDailyFortune(info: FortuneSaveInfo, for date: Date = Date()) {
        let encoder = JSONEncoder()
        let key = fortuneIdKey(for: date)
        if let encoded = try? encoder.encode(info) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    /// 오늘 날짜 기준으로 저장된 DailyFortuneResponse의 id를 읽어옴
    func dailyFortune(for date: Date = Date()) -> FortuneSaveInfo? {
        let key = fortuneIdKey(for: date)
        guard let savedData = UserDefaults.standard.data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(FortuneSaveInfo.self, from: savedData)
    }
}
