//
//  Hour.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public struct Hour: Codable, Hashable {
    public let value: Int
    
    public func to24Hour(with meridiem: Meridiem) -> Int {
        switch meridiem {
        case .am:
            return value == 12 ? 0 : value
        case .pm:
            return (value == 12 ? value : value + 12)
        }
    }
    
    public init?(_ value: Int) {
        guard (1...12).contains(value) else { return nil }
        self.value = value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

