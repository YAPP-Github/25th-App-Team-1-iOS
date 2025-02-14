//
//  BornTimeData.swift
//  FeatureCommonEntity
//
//  Created by choijunios on 2/13/25.
//

public struct BornTimeData: Equatable {
    public var meridiem: Meridiem
    public var hour: Hour
    public var minute: Minute
    
    public init(meridiem: Meridiem, hour: Hour, minute: Minute) {
        self.meridiem = meridiem
        self.hour = hour
        self.minute = minute
    }
}

public extension BornTimeData {
    func toTimeString() -> String {
        switch meridiem {
        case .am:
            String(format: "%02d:%02d", hour.value, minute.value)
        case .pm:
            String(format: "%02d:%02d", hour.value + 12, minute.value)
        }
    }
}
