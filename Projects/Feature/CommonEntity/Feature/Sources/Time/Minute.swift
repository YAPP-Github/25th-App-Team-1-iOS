//
//  Minute.swift
//  FeatureCommonEntity
//
//  Created by 손병근 on 2/1/25.
//

import Foundation

public struct Minute: Codable, Hashable {
    public let value: Int
    
    public init?(_ value: Int) {
        guard (0...59).contains(value) else { return nil }
        self.value = value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}
