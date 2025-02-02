//
//  Hour.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public struct Hour {
    public let value: Int
    
    public init?(_ value: Int) {
        guard (0...23).contains(value) else { return nil }
        self.value = value
    }
    
    public var meridiem: Meridiem {
        return value < 12 ? .am : .pm
    }
    
    /// 12시간제 변환 (1~12)
    public var hour12: Int {
        return value == 0 ? 12 : (value > 12 ? value - 12 : value)
    }
}

