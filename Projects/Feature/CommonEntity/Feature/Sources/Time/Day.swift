//
//  Day.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public struct Day: Equatable {
    public let value: Int
    
    public init?(_ value: Int, month: Month, year: Year) {
        let lastDay = Day.lastDay(of: month, in: year)
        guard (1...lastDay).contains(value) else { return nil }
        self.value = value
    }
    
    public static func lastDay(of month: Month, in year: Year) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = year.value
        dateComponents.month = month.rawValue

        let calendar = Calendar.current
        
        // 해당 월의 첫날을 구한 뒤, 마지막 날을 계산
        if let date = calendar.date(from: dateComponents),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return range.upperBound - 1
        }
        
        return 31 // 기본값
    }
}
