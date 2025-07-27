//
//  Mission.swift
//  FeatureCommonEntity
//
//  Created by ever on 1/27/25.
//

import Foundation

public struct Mission: Equatable {
    public enum MissionType: String, Equatable {
        case shake = "shake"
        case tap = "tap"
    }
    
    public let type: MissionType
    public let count: Int
    
    public init(type: MissionType, count: Int) {
        self.type = type
        self.count = count
    }
    
    public var displayTitle: String {
        switch type {
        case .shake:
            return "흔들기 \(count)회"
        case .tap:
            return "터치하기 \(count)회"
        }
    }
    
    public static var `default`: Mission {
        Mission(type: .tap, count: 10)
    }
}