//
//  Hour.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public struct Hour: Codable, Hashable {
    public let value: Int
    
    public init?(_ value: Int) {
        guard (0...11).contains(value) else { return nil }
        self.value = value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

